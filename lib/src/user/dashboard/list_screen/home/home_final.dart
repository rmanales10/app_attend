import 'package:app_attend/src/user/api_services/auth_service.dart';
import 'package:app_attend/src/user/api_services/firestore_service.dart';
import 'package:app_attend/src/user/widgets/color_constant.dart';
import 'package:app_attend/src/user/widgets/status_widget.dart';
import 'package:app_attend/src/user/widgets/time_clock.dart';
import 'package:app_attend/src/user/widgets/time_controller.dart';
import 'package:app_attend/src/user/widgets/upcoming_reminder.dart';
import 'package:app_attend/src/user/widgets/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeFinal extends StatefulWidget {
  const HomeFinal({super.key});

  @override
  State<HomeFinal> createState() => _HomeFinalState();
}

class _HomeFinalState extends State<HomeFinal> {
  late TimeController timeController;
  late AuthService authService;
  late FirestoreService firestoreService;
  RxString selectedSubject = ''.obs;
  RxList<String> subjectNames = <String>[].obs;
  Rx<DateTime> date = DateTime.now().obs;
  RxString time = "".obs;

  @override
  void initState() {
    super.initState();
    timeController = Get.put(TimeController());
    authService = Get.put(AuthService());
    firestoreService = Get.put(FirestoreService());

    // Fetch user data and subjects/sections if user is authenticated
    if (authService.currentUser != null) {
      firestoreService.fetchUserData(authService.currentUser!.uid);
      firestoreService
          .fetchSectionsAndSubjects(userId: authService.currentUser!.uid)
          .then((_) {
        subjectNames.value = firestoreService.subjects
            .map((record) {
              final subject = record['subject'] as String;
              final section = record['section'] as String;
              final recordTime = record['time'] as String;
              final timestamp = record['date'];

              DateTime recordDate;
              if (timestamp is Timestamp) {
                recordDate = timestamp.toDate();
              } else if (timestamp is DateTime) {
                recordDate = timestamp;
              } else {
                recordDate = DateTime.now();
              }

              // Format date as MM/dd/yyyy for consistent formatting
              final dateTime = DateFormat('MM/dd/yyyy').format(recordDate);
              final formattedString = '$subject $section $dateTime $recordTime';
              return formattedString;
            })
            .toSet()
            .toList();

        // Initialize selected subject if the list is not empty
        if (subjectNames.isNotEmpty) {
          selectedSubject.value = subjectNames[0];
          _updateDateTimeFromSelection(subjectNames[0]);
        }
      });
    }
  }

  void _updateDateTimeFromSelection(String selected) {
    print('Selected item: $selected'); // Debug: Print the selected item

    // Split the selected string by spaces
    final parts = selected.split(' ');

    // Ensure there are enough parts to extract date and time
    if (parts.length < 2) {
      print('Error: Selected string format does not match expected pattern');
      return;
    }

    // Extract date and time strings (the last two parts)
    final selectedDateTimeStr =
        '${parts[parts.length - 2]} ${parts[parts.length - 1]}';

    try {
      // Parse the combined date and time string
      final selectedDateTime =
          DateFormat('MM/dd/yyyy hh:mm a').parse(selectedDateTimeStr);

      // Set the date and time values
      date.value = selectedDateTime;
      time.value =
          DateFormat('hh:mm a').format(selectedDateTime); // Format time only
    } catch (e) {
      print('Error parsing date and time: $e'); // Log parsing error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              // User profile widget
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: blue,
                    ),
                    child: UserProfileWidget(
                      name: firestoreService.userData['fullname'] ?? '',
                      email: 'Instructor',
                      profileImageUrl: 'assets/logo.png',
                    ),
                  )),
              const SizedBox(height: 20),

              // Time clock widget
              Obx(() => TimeClockWidget(
                    time: timeController.currentTime.value,
                    role: timeController.timeOfDay.value,
                  )),
              const SizedBox(height: 20),

              // Dropdown for subject selection
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: selectList(selectedSubject, subjectNames),
              ),
              const SizedBox(height: 20),

              // InOutStatus widget with live date and time
              Obx(() => InOutStatusWidget(
                    inCount: firestoreService.presentCount.value,
                    breakCount: firestoreService.totalCount.value,
                    outCount: firestoreService.absentCount.value,
                    dateTime:
                        '${DateFormat('EEEE, d MMM yyyy').format(date.value)} ${time.value}',
                    firstIn: time.value,
                    lastOut: "",
                  )),
              const SizedBox(height: 20),

              // Upcoming reminders widget
              UpcomingRemindersWidget(
                reminders: [
                  Reminder(
                    month: "May",
                    day: 27,
                    notes: ["Pay period cycle ends in 2 days"],
                  ),
                  Reminder(
                    month: "May",
                    day: 28,
                    notes: ["Labour Day", "Timesheet approvals due date"],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Dropdown list for selecting a subject
  Container selectList(RxString selectedValue, RxList<String> items) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => DropdownButton<String>(
          value: selectedValue.value,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          underline: const SizedBox(),
          style: const TextStyle(color: Colors.black),
          onChanged: (String? newValue) {
            if (newValue != null) {
              selectedValue.value = newValue;
              _updateDateTimeFromSelection(newValue);
            }
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isExpanded: true,
        ),
      ),
    );
  }
}
