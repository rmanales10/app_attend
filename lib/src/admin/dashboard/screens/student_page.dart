import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Student Button inside the Card
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showAddStudentDialog(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Horizontal scrollable Data Table
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 40,
                      columnSpacing: 30, // Adjust column spacing as needed
                      headingRowColor:
                          MaterialStateProperty.all(Colors.blueGrey.shade100),
                      columns: [
                        DataColumn(
                            label: Text('Student ID',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Student Name',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Grade',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Section',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        _buildDataRow('S001', 'Alice Johnson', 'Grade 10', 'A'),
                        _buildDataRow('S002', 'Bob Smith', 'Grade 10', 'B'),
                        _buildDataRow('S003', 'Carol Lee', 'Grade 11', 'A'),
                        _buildDataRow('S004', 'David Kim', 'Grade 12', 'C'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(String id, String name, String grade, String section) {
    return DataRow(
      cells: [
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(id),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(name),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(grade),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(section),
        )),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () {
                // Edit functionality
              },
              icon: Icon(Icons.edit),
              color: Colors.blue,
            ),
            IconButton(
              onPressed: () {
                // Delete functionality
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        )),
      ],
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    final _idController = TextEditingController();
    final _nameController = TextEditingController();
    final _gradeController = TextEditingController();
    final _sectionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'Student ID'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Student Name'),
                ),
                TextField(
                  controller: _gradeController,
                  decoration: InputDecoration(labelText: 'Grade'),
                ),
                TextField(
                  controller: _sectionController,
                  decoration: InputDecoration(labelText: 'Section'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle adding new student (e.g., save data and update the table)
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
