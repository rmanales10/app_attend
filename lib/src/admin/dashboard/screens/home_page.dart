import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> holidays = [
      {"date": "Monday 29 July", "name": "Eid - Al - Ada"},
      {"date": "Tuesday 15 August", "name": "Independence Day"},
      {"date": "Wednesday 16 August", "name": "Parsi New Year"},
      {"date": "Tuesday 29 August", "name": "Onam"},
      {"date": "Wednesday 16 August", "name": "Raksha Bandhan"},
    ];

    final Map<String, Color> iconColors = {
      "Eid - Al - Ada": Colors.orange,
      "Independence Day": Colors.teal,
      "Parsi New Year": Colors.green,
      "Onam": Colors.teal,
      "Raksha Bandhan": Colors.green,
    };
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 5),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cardBox(0, 'Total Teachers', Icons.people_alt),
                  cardBox(0, 'Total Students', Icons.people_alt),
                  cardBox(0, 'Total Sections', Icons.people_alt),
                  cardBox(0, 'Total Subjects', Icons.people_alt),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 700,
                    height: 450,
                    padding: EdgeInsets.all(16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildProgressItem("Today", 3.45, 8, Colors.teal),
                        _buildProgressItem("This Week", 28, 40, Colors.red),
                        _buildProgressItem(
                            "This Month", 90, 160, Colors.orange),
                        _buildProgressItem("Remaining", 90, 160, Colors.blue),
                        _buildProgressItem("Overtime", 5, null, Colors.yellow),
                      ],
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 450,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming Holidays',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: holidays.length,
                              itemBuilder: (context, index) {
                                String date = holidays[index]["date"]!;
                                String name = holidays[index]["name"]!;
                                Color iconColor =
                                    iconColors[name] ?? Colors.grey;

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: iconColor,
                                    radius: 5,
                                  ),
                                  title: Text(
                                    date,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  subtitle: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container cardBox(int total, String label, IconData icon) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '$total',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
      String title, double value, double? total, Color color) {
    double progress = total != null ? (value / total) : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                total != null
                    ? '${value.toStringAsFixed(2)} / $total hrs'
                    : '${value.toStringAsFixed(0)} hrs',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: color,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
