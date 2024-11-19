import 'package:app_attend/src/admin/dashboard/screens/subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageSubjectsPage extends StatelessWidget {
  const ManageSubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
     final List<Map<String, dynamic>> stats = [
      {
        'category': 'PROGRAMMING',
        'title': 'Complete Python Bootcamp\nGo from zero.',
        'Instructor': 'Emily Thomas',
        'progress': 0.3,
        'color': Colors.amber,
      },
       {
        'category': 'PROGRAMMING',
        'title': 'Complete Python Bootcamp\nGo from zero.',
        'Instructor': 'Emily Thomas',
        'progress': 0.3,
        'color': Colors.amber,
      },
       {
        'category': 'PROGRAMMING',
        'title': 'Complete Python Bootcamp\nGo from zero.',
        'Instructor': 'Emily Thomas',
        'progress': 0.3,
        'color': Colors.amber,
      },
      
    ];


    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Academic Course',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               
                ElevatedButton(
            onPressed: () {
              // Add Academic Pool logic
            },
            child: Text('+ Add Subject'),
          ),
                
              ],
            ),
            SizedBox(height: 16),

            // Stats Cards
           Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: stats.map((stat) {
            return Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category Label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: stat['color'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text(
                              stat['category'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Icon(Icons.more_vert, color: Colors.grey),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Course Title
                      Text(
                        stat['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),

                      // Author and Progress
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instructor:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                stat['Instructor'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
           Get.to(EditSubjectPage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: stat['color'], // Use the color dynamically
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'Manage Course',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
                        ],
                      ),
                    ],
                  ),
           ] ),
              ),
             ) );
          }).toList(),
        ),
          ],
        ),
      ),
         
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Save logic
                  },
                  child: Text('Save'),
                ),
              ],
            ),]
          
        ),
     ) );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ManageSubjectsPage(),
  ));
}
