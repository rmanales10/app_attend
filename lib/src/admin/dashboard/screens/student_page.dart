import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_attend/src/admin/firebase/firestore.dart';

class StudentPage extends StatelessWidget {
  StudentPage({super.key});

  final Firestore _firestore = Get.put(Firestore());

  @override
  Widget build(BuildContext context) {
    final idNumber = TextEditingController();
    final fullName = TextEditingController();
    final section = TextEditingController();
    _firestore.getAllStudent();

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
                    'Student\'s List',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: Text('Add Student'),
                          content: SizedBox(
                            height: 180,
                            width: 300,
                            child: Column(
                              children: [
                                inputStudentField('ID Number', idNumber),
                                SizedBox(height: 10),
                                inputStudentField('Fullname', fullName),
                                SizedBox(height: 10),
                                inputStudentField('Section', section),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  _firestore.addStudent(
                                      fullname: fullName.text,
                                      idnumber: idNumber.text,
                                      section: section.text);
                                  _firestore.getAllStudent();
                                  Get.back();
                                  Get.snackbar(
                                      'Success', 'Student added successfully');
                                  fullName.clear();
                                  idNumber.clear();
                                  section.clear();
                                },
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
                      DataColumn(label: Text('No.')),
                      DataColumn(label: Text('ID Number')),
                      DataColumn(label: Text('Fullname')),
                      DataColumn(label: Text('Section')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _firestore.studentData.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      Map<String, dynamic> user = entry.value;

                      return DataRow(cells: [
                        DataCell(Text(index.toString())), // Row number
                        DataCell(Text(user['idnumber'])), // Row number
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

  TextField inputStudentField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }
}
