import 'package:app_attend/src/admin/dashboard/screens/students/student_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_attend/src/admin/firebase/firestore.dart';

class StudentPage extends StatelessWidget {
  StudentPage({super.key});

  final Firestore _firestore = Get.put(Firestore());
  final _controller = Get.put(StudentController());

  final name = TextEditingController();
  final section = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final selectedYear = '1st Year'.obs;
  final List<String> year = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];
  final selectedDepartment = 'BSIT'.obs;
  final List<String> department = [
    'BSIT',
    'BFPT',
    'BTLED - HE',
    'BTLED - ICT',
    'BTLED - IA',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Students',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: Text('Add Student'),
                          content: SizedBox(
                            height: 350,
                            width: 300,
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text('Name')),
                                  inputStudentField('ex: Mercedes, Maria P.',
                                      name, validator),
                                  SizedBox(height: 10),
                                  Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text('Year Level')),
                                  _buildDropdownSection(
                                    selectedValue: selectedYear,
                                    options: year,
                                    onChanged: (newValue) {
                                      selectedYear.value = newValue!;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text('Department & Block')),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 135,
                                        child: _buildDropdownSection(
                                          selectedValue: selectedDepartment,
                                          options: department,
                                          onChanged: (newValue) {
                                            selectedDepartment.value =
                                                newValue!;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 50,
                                        child: inputStudentField(
                                            'E', section, validator),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: addStudent, child: Text('Submit')),
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('Cancel'))
                          ],
                        ));
                      },
                      child: Row(
                        children: [Icon(Icons.add), Text('Add Student')],
                      ))
                ],
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(() {
                  _firestore.getAllStudent();
                  if (_firestore.studentData.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Build the DataTable rows dynamically
                  return DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Year Level')),
                      DataColumn(label: Text('Section')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _firestore.studentData.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      Map<String, dynamic> user = entry.value;

                      return DataRow(cells: [
                        DataCell(Text(index.toString())), // Row number
                        DataCell(Text(user['name'] ?? 'N/A')),
                        DataCell(Text(user['year_level'] ?? 'N/A')),
                        DataCell(Text(user['section'] ?? 'N/A')),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.edit)),
                            IconButton(
                              onPressed: () {
                                Get.dialog(AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text(
                                      'Are you sure you want to delete this?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _firestore.deleteStudent(user['id']);
                                        Get.back();
                                        Get.snackbar('Success',
                                            'User deleted successfully');
                                        _firestore.getAllStudent();
                                      },
                                      child: Text('Yes'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Get.back(),
                                      child: Text('No'),
                                    ),
                                  ],
                                ));
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addStudent() {
    final departmentBlock = selectedYear.value.contains('1')
        ? '1${section.text}'
        : selectedYear.value.contains('2')
            ? '2${section.text}'
            : selectedYear.value.contains('3')
                ? '3${section.text}'
                : '4${section.text}';
    _controller.addStudent(
        name: name.text,
        yearLevel: selectedYear.value,
        section: '$selectedDepartment - $departmentBlock');
    Get.back();
    Get.snackbar('Success', 'Student added Successfully');
  }

  TextFormField inputStudentField(String label,
      TextEditingController controller, FormFieldValidator<String> validator) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  String? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a valid';
    }
    return null;
  }
}

Widget _buildDropdownSection({
  required RxString selectedValue,
  required List<String> options,
  required ValueChanged<String?> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
