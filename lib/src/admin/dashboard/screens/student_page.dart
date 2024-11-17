import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:app_attend/src/admin/firebase/firestore.dart';

class StudentPage extends StatelessWidget {
  StudentPage({super.key});

  final Firestore _firestore = Get.put(Firestore());

  @override
  Widget build(BuildContext context) {
    // Fetch users when the widget is built
    _firestore.fetchAllUsers();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            height: 300,
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: 'IdNumber',
                                      border: OutlineInputBorder()),
                                ),
                              ],
                            ),
                          ),
                        ));
                      },
                      child: Row(
                        children: [Icon(Icons.add), Text('Add Student')],
                      ))
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 150),
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
                    if (_firestore.allUsers.isEmpty) {
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
                        DataColumn(label: Text('Fullname')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone Number')),
                        DataColumn(label: Text('Created at')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _firestore.allUsers.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        Map<String, dynamic> user = entry.value;

                        // Convert Firestore Timestamp to a formatted DateTime string
                        String formattedDate = user['createdAt'] != null
                            ? DateFormat('yyyy-MM-dd HH:mm').format(
                                (user['createdAt'] as Timestamp).toDate())
                            : 'N/A';

                        return DataRow(cells: [
                          DataCell(Text('$index')), // Row number
                          DataCell(Text(user['fullname'] ?? 'N/A')),
                          DataCell(Text(user['email'] ?? 'N/A')),
                          DataCell(Text(user['phone'] ?? 'N/A')),
                          DataCell(Text(formattedDate)), // Formatted DateTime
                          DataCell(IconButton(
                            onPressed: () {
                              Get.dialog(AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                    'Are you sure you want to delete this?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _firestore.deleteUser(user['id']);
                                      Get.back();
                                      Get.snackbar('Success',
                                          'User deleted successfully');
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
                          )),
                        ]);
                      }).toList(),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
