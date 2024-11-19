import 'package:app_attend/src/admin/dashboard/screens/Student_page.dart';
import 'package:app_attend/src/admin/dashboard/screens/home_page.dart';
import 'package:app_attend/src/admin/dashboard/screens/subject1.dart';
import 'package:app_attend/src/admin/dashboard/screens/teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Track the current page
  String currentPage = 'Dashboard';

  void setPage(String page) {
    setState(() {
      currentPage = page;
    });
  }

  Widget getContent() {
    switch (currentPage) {
      case 'Dashboard':
        return HomePage();
      case 'Teacher':
        return TeacherPage();
      case 'StudentsList':
        return StudentPage();
       case 'Subjects':
        return ManageSubjectsPage();
      // case 'Profile':
      //   return PersonalInfoPage();
      default:
        return Center(child: Text('Main Content Area'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            currentPage: currentPage,
            onPageSelected: setPage,
          ),
          Expanded(
            child: getContent(),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final String currentPage;
  final Function(String) onPageSelected;

  const Sidebar({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLightMode = false;

    return Material(
      color: Color(0xFF1E1E2C),
      child: SizedBox(
        width: 250,
        height: screenHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 40),
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: 50,
                  ),
                  Text('Tap Attend',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('CL', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rolan Manales',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('Admin', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Box

              SizedBox(height: 20),

              // Menu Items
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuItem(
                    Icons.home,
                    'Dashboard',
                    isSelected: currentPage == 'Dashboard',
                    onTap: () => onPageSelected('Dashboard'),
                  ),
                  _buildMenuItem(
                    Icons.people,
                    'Teacher\'s List',
                    isSelected: currentPage == 'Teacher',
                    onTap: () => onPageSelected('Teacher'),
                  ),
                  _buildMenuItem(
                    Icons.star_border,
                    "Student's List",
                    isSelected: currentPage == 'StudentsList',
                    onTap: () => onPageSelected('StudentsList'),
                  ),
                  _buildMenuItem(
                    Icons.book,
                    "Subjects",
                    isSelected: currentPage == 'Subjects',
                    onTap: () => onPageSelected('Subjects'),
                  ),
                  // _buildMenuItem(
                  //   Icons.analytics,
                  //   'Profile',
                  //   isSelected: currentPage == 'Profile',
                  //   onTap: () => onPageSelected('Profile'),
                  // ),
                ],
              ),

              // Bottom Section with Logout and Light Mode Toggle
              Divider(color: Colors.grey),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.grey),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () => Get.offAllNamed('/login'),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build menu items with an optional selected state
  Widget _buildMenuItem(
    IconData icon,
    String title, {
    bool isSelected = false,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.grey[800] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTap,
    );
  }
}
