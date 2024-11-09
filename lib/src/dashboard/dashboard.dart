import 'package:app_attend/src/dashboard/list_screen/attendance_screen.dart';
import 'package:app_attend/src/dashboard/list_screen/home_screen.dart';
import 'package:app_attend/src/widgets/color_constant.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final items = ['Item 1', 'Item 2', 'Item 3'];

  int _currentIndex = 0;

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(child: Text(item));
  List<Widget> body = [
    HomeScreen(),
    AttendanceScreen(),
    Icon(Icons.report),
    Icon(Icons.person_off_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      body: body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        selectedItemColor: blue, // Color for selected icon
        unselectedItemColor: Colors.black, // Color for unselected icons
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Attendance',
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            label: 'Notification',
            icon: Icon(Icons.report),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person_off_outlined),
          ),
        ],
      ),
    );
  }
}
