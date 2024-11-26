import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_attend/src/admin/firebase/firestore.dart';

class SectionPage extends StatelessWidget {
  SectionPage({super.key});

  final Firestore _firestore = Get.put(Firestore());

  @override
  Widget build(BuildContext context) {
    final idNumber = TextEditingController();
    final fullName = TextEditingController();
    final section = TextEditingController();
    final formkey = GlobalKey<FormState>();
    _firestore.getAllStudent();

    addStudent() {
      if (formkey.currentState?.validate() == true) {
        _firestore.addStudent(
            fullname: fullName.text,
            idnumber: idNumber.text,
            section: section.text);
        _firestore.getAllStudent();
        Get.back();
        // Get.snackbar('Success', 'Student added successfully');
        fullName.clear();
        idNumber.clear();
        section.clear();
      }
    }

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
                    'Sections',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: Text('Add Student'),
                          content: SizedBox(
                            height: 230,
                            width: 300,
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text('Name of Student')),
                                  inputStudentField('Ex: Mercedes, Maria P.',
                                      fullName, fullNameValidator),
                                  SizedBox(height: 10),
                                  Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text('Course & Year')),
                                  inputStudentField('Ex: BSIT - 2E', section,
                                      courseValidator),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () => addStudent(),
                                child: Text('Submit')),
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('Cancel'))
                          ],
                        ));
                      },
                      child: Row(
                        children: [Icon(Icons.add), Text('Add Section')],
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
                  // Display a loading indicator while fetching
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
                      DataColumn(label: Text('Section')),
                      DataColumn(label: Text('Year Level')),
                      DataColumn(label: Text('Instructor')),
                      DataColumn(label: Text('Students')),
                      DataColumn(label: Text('Acions')),
                    ],
                    rows: _firestore.studentData.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      Map<String, dynamic> user = entry.value;

                      return DataRow(cells: [
                        DataCell(Text(index.toString())), // Row number
                        DataCell(Text(user['fullname'] ?? 'N/A')),
                        DataCell(Text(user['fullname'] ?? 'N/A')),

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

  String? fullNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    // Split the input by spaces
    List<String> nameParts = value.trim().split(' ');

    // Check if there are at least two words
    if (nameParts.length < 2) {
      return 'Please enter both first and last names';
    }

    // Check if each word starts with a capital letter (optional)
    for (String part in nameParts) {
      if (part.isEmpty || part[0] != part[0].toUpperCase()) {
        return 'Each name should start with a capital letter';
      }
    }

    return null; // Validation passed
  }

  String? courseValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter course & year';
    }

    return null; // Validation passed
  }
}
