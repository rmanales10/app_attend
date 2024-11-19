import 'package:flutter/material.dart';

class EditSubjectPage extends StatelessWidget {
  const EditSubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Dropdown options for Subject Teacher
    final List<String> teachers = ['Adam Hodgson', 'John Doe', 'Jane Smith'];
    String selectedTeacher = teachers[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Edit Subject Details',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Subject Field
                  TextFormField(
                    initialValue: 'Social Science',
                    decoration: InputDecoration(
                      labelText: 'Subject *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the subject name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Subject Code Field
                  TextFormField(
                    initialValue: '004',
                    decoration: InputDecoration(
                      labelText: 'Subject Code (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Book Name Field
                  // Subject Teacher Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedTeacher,
                    items: teachers.map((String teacher) {
                      return DropdownMenuItem<String>(
                        value: teacher,
                        child: Text(teacher),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Subject Teacher (Incharge)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      selectedTeacher = newValue!;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Perform update operation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Updated Successfully!')),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text('Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditSubjectPage(),
  ));
}
