import 'dart:developer';
import 'package:app_attend/src/api_services/auth_service.dart';
import 'package:app_attend/src/api_services/firestore_service.dart';
import 'package:app_attend/src/widgets/color_constant.dart';
import 'package:app_attend/src/widgets/status_widget.dart';
import 'package:app_attend/src/widgets/time_clock.dart';
import 'package:app_attend/src/widgets/time_controller.dart';
import 'package:app_attend/src/widgets/upcoming_reminder.dart';
import 'package:app_attend/src/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeFinal extends StatefulWidget {
  const HomeFinal({super.key});

  @override
  State<HomeFinal> createState() => _HomeFinalState();
}

class _HomeFinalState extends State<HomeFinal> {
  @override
  Widget build(BuildContext context) {
    final timeController = Get.put(TimeController());
    final authService = Get.put(AuthService());
    final firestoreService = Get.put(FirestoreService());

    // Fetching user data and sections/subjects if currentUser is not null
    if (authService.currentUser != null) {
      firestoreService.fetchUserData(authService.currentUser!.uid);
      firestoreService.fetchSectionsAndSubjects(
          userId: authService.currentUser!.uid);
    }

    final sections = firestoreService.sections;
    final selectedSection = sections.isNotEmpty ? sections[0].obs : "".obs;
    final subjects = firestoreService.subjects;
    final selectedSubject = subjects.isNotEmpty ? subjects[0].obs : "".obs;
    final absentCount = firestoreService.absentCount;
    final presentCount = firestoreService.presentCount;
    final totalCount = firestoreService.totalCount;

    Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
    final DateFormat dateFormat = DateFormat('MM/dd/yyyy');

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        selectedDate.value = picked;
        await firestoreService.getAllAttendanceStatus(
          userId: authService.currentUser!.uid,
          date: selectedDate.value!,
          section: selectedSection.value,
          subject: selectedSubject.value,
        );

        if (firestoreService.attendanceId.value.isNotEmpty) {
          await firestoreService.getAttendanceCounts(
            userId: authService.currentUser!.uid,
            attendanceId: firestoreService.attendanceId.value,
          );
        } else {
          log("No attendance record found for the selected date.");
        }
      }
    }

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
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              Obx(() => TimeClockWidget(
                    time: timeController.currentTime.value,
                    role: timeController.timeOfDay.value,
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  selectList(selectedSection, sections),
                  selectDateWidget(
                      selectDate, context, selectedDate, dateFormat),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                  width: 300, child: selectList(selectedSubject, subjects)),
              const SizedBox(height: 20),
              Obx(() => InOutStatusWidget(
                    inCount: presentCount.value,
                    breakCount: totalCount.value,
                    outCount: absentCount.value,
                    dateTime: DateFormat('EEEE, d MMM yyyy h:mm a')
                        .format(DateTime.now()),
                    firstIn: "8:32 am",
                    lastOut: "--:--",
                  )),
              const SizedBox(height: 20),
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

  GestureDetector selectDateWidget(
    Future<void> Function(BuildContext) selectDate,
    BuildContext context,
    Rx<DateTime?> selectedDate,
    DateFormat dateFormat,
  ) {
    return GestureDetector(
      onTap: () => selectDate(context),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
                  selectedDate.value != null
                      ? dateFormat.format(selectedDate.value!)
                      : 'MM/DD/YYYY',
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }

  Container selectList(RxString selectedValue, List<String> items) {
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
            if (newValue != null) selectedValue.value = newValue;
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
