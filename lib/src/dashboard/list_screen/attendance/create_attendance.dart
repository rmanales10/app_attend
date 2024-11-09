import 'package:app_attend/src/api_services/auth_service.dart';
import 'package:app_attend/src/api_services/firestore_service.dart';
import 'package:app_attend/src/widgets/color_constant.dart';
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

  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('MM/dd/yyyy');

  // Drop-down variables
  String selectedSection = 'BSIT - 3A';
  final List<String> sections = [
    'BSIT - 3A',
    'BSIT - 3B',
    'BSIT - 3C',
    'BSIT - 3D',
    'BSIT - 3E',
    'BSIT - 3F',
  ];
  String selectedSubject = 'Information Assurance Security';
  final List<String> subjects = [
    'Information Assurance Security',
    'Networking 2',
    'Mobile Programming',
    'Software Engineering',
    'IT Elective 1',
    'Technopreneurship',
  ];

  List<Map<String, dynamic>>? attendanceRecords;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendanceRecords();
  }

  Future<void> fetchAttendanceRecords() async {
    try {
      if (_authService.currentUser != null) {
        await _firestore.retrieveAttendance(
            userId: _authService.currentUser!.uid);
        setState(() {
          attendanceRecords = _firestore.attendanceRecords;
        });
      }
    } catch (e) {
      print('Error fetching attendance records: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
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
                _buildDropdownSection(
                  label: 'Select Section:',
                  selectedValue: selectedSection,
                  options: sections,
                  onChanged: (newValue) {
                    setState(() {
                      selectedSection = newValue!;
                    });
                  },
                ),
                Column(
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
                            Text(
                              selectedDate != null
                                  ? dateFormat.format(selectedDate!)
                                  : 'MM/DD/YYYY',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                    setState(() {
                      selectedSubject = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                attendanceDisplay(),
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
    required String selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(
          height: 40,
          width: 150,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                dropdownColor: Colors.grey[300],
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(value),
                    ),
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
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (attendanceRecords == null || attendanceRecords!.isEmpty) {
      return Text('No attendance records found');
    } else {
      final attendanceRecord = attendanceRecords!.first;
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
        onPressed: () {
          if (selectedDate != null) {
            _firestore.storeAttendance(
              userId: _authService.currentUser?.uid ?? '',
              date: selectedDate!,
              section: selectedSection,
              subject: selectedSubject,
            );
            Get.back();
          } else {
            Get.snackbar('Error', 'Please select a date!',
                snackPosition: SnackPosition.TOP);
          }
        },
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
