import 'dart:developer';

import 'package:app_attend/src/api_services/auth_service.dart';
import 'package:app_attend/src/api_services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateAttendance extends StatefulWidget {
  const CreateAttendance({super.key});

  @override
  State<CreateAttendance> createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  final AuthService _authService = Get.put(AuthService());
  final FirestoreService _firestore = Get.put(FirestoreService());

  final selectedDate = Rxn<DateTime>();
  final dateFormat = DateFormat('MM/dd/yyyy');

  // Drop-down reactive variables
  final selectedSection = 'BSIT - 3A'.obs;
  final List<String> sections = [
    'BSIT - 3A',
    'BSIT - 3B',
    'BSIT - 3C',
    'BSIT - 3D',
    'BSIT - 3E',
    'BSIT - 3F',
  ];

  final selectedSubject = 'Information Assurance Security'.obs;
  final List<String> subjects = [
    'Information Assurance Security',
    'Networking 2',
    'Mobile Programming',
    'Software Engineering',
    'IT Elective 1',
    'Technopreneurship',
  ];

  RxList<Map<String, dynamic>> attendanceRecords = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    fetchAttendanceRecords();
  }

  Future<void> fetchAttendanceRecords() async {
    try {
      isLoading.value = true;
      if (_authService.currentUser != null) {
        await _firestore.retrieveAttendance(
            userId: _authService.currentUser!.uid);
        attendanceRecords.assignAll(_firestore.attendanceRecords);
      }
    } catch (e) {
      log('Error fetching attendance records: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> createAttendanceRecord() async {
    if (selectedDate.value == null) {
      Get.snackbar('Error', 'Please select a date!',
          snackPosition: SnackPosition.TOP);
      return;
    }
    try {
      final String userId = _authService.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User ID is required');
      }

      // Get or create the attendance ID
      await _firestore.getOrCreateAttendanceId(
        userId: userId,
        date: selectedDate.value!,
        section: selectedSection.value,
        subject: selectedSubject.value,
      );

      // Refresh the attendance records after creation
      await fetchAttendanceRecords();
      Get.back();
      // Navigate back
    } catch (e) {
      log('Error creating attendance record: $e');
      Get.snackbar('Error', 'Failed to create attendance record',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Attendance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: _buildDropdownSection(
                    label: 'Select Section:',
                    selectedValue: selectedSection,
                    options: sections,
                    onChanged: (newValue) {
                      selectedSection.value = newValue!;
                    },
                  ),
                ),
                SizedBox(width: 20), // Add spacing between widgets
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Date:'),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildDropdownSection(
                  label: 'Select Subject:',
                  selectedValue: selectedSubject,
                  options: subjects,
                  onChanged: (newValue) {
                    selectedSubject.value = newValue!;
                  },
                ),
                const SizedBox(height: 20),
                Obx(() => attendanceDisplay()),
                const SizedBox(height: 20),
                addAttendanceButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection({
    required String label,
    required RxString selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue.value,
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                dropdownColor: Colors.grey[300],
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget attendanceDisplay() {
    if (isLoading.value) {
      return CircularProgressIndicator();
    } else if (attendanceRecords.isEmpty) {
      return Text('No attendance records found');
    } else {
      final attendanceRecord = attendanceRecords.first;
      return Text('Last subject: ${attendanceRecord['subject']}');
    }
  }

  Widget addAttendanceButton() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: TextButton(
        onPressed: createAttendanceRecord,
        child: const Row(
          children: [
            Icon(Icons.add_circle_outline),
            SizedBox(width: 15),
            Text('Add Attendance', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
