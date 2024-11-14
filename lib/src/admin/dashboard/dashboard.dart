import 'package:flutter/material.dart';

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
        return Center(child: Text('Dashboard Content'));
      case 'Revenue':
        return Center(child: Text('Revenue Content'));
      case 'Notifications':
        return Center(child: Text('Notifications Content'));
      case 'Analytics':
        return Center(child: Text('Analytics Content'));
      case 'Likes':
        return Center(child: Text('Likes Content'));
      case 'Wallets':
        return Center(child: Text('Wallets Content'));
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
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLightMode = false;

    return Material(
      color: Color(0xFF1E1E2C),
      child: Container(
        width: 250,
        height: screenHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
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
                        Text('Codinglab',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('Web developer',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Search Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.grey[800],
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Menu Items
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuItem(
                    Icons.dashboard,
                    'Dashboard',
                    isSelected: currentPage == 'Dashboard',
                    onTap: () => onPageSelected('Dashboard'),
                  ),
                  _buildMenuItem(
                    Icons.bar_chart,
                    'History',
                    isSelected: currentPage == 'Revenue',
                    onTap: () => onPageSelected('Revenue'),
                  ),
                  _buildMenuItem(
                    Icons.notifications,
                    'Notifications',
                    isSelected: currentPage == 'Notifications',
                    onTap: () => onPageSelected('Notifications'),
                  ),
                  _buildMenuItem(
                    Icons.analytics,
                    'Analytics',
                    isSelected: currentPage == 'Analytics',
                    onTap: () => onPageSelected('Analytics'),
                  ),
                  _buildMenuItem(
                    Icons.favorite,
                    'Likes',
                    isSelected: currentPage == 'Likes',
                    onTap: () => onPageSelected('Likes'),
                  ),
                  _buildMenuItem(
                    Icons.account_balance_wallet,
                    'Wallets',
                    isSelected: currentPage == 'Wallets',
                    onTap: () => onPageSelected('Wallets'),
                  ),
                ],
              ),

              // Bottom Section with Logout and Light Mode Toggle
              Divider(color: Colors.grey),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.grey),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.light_mode, color: Colors.grey),
                title:
                    Text('Light Mode', style: TextStyle(color: Colors.white)),
                trailing: Switch(
                  value: isLightMode,
                  onChanged: (value) {
                    // Toggle light mode here
                  },
                ),
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

class StudentList extends StatelessWidget {
  final List<Map<String, String>> students = [
    {'id': '2022345634', 'name': 'Abella, Alvin'},
    {'id': '2022347834', 'name': 'Binaoro, Kent'},
    {'id': '2022344534', 'name': 'Catalan, Ben'},
    {'id': '2022349034', 'name': 'Daniel, Mae'},
    {'id': '2022343034', 'name': 'Espito, Anne'},
    {'id': '2022349067', 'name': 'Espina, Angel'},
    {'id': '2022349034', 'name': 'Flores, Mae'},
    {'id': '2022349034', 'name': 'Maglinas, April'},
    {'id': '2022349034', 'name': 'Ozaraga, Honey'},
    {'id': '2022349034', 'name': 'Zyl, Ryl'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'List of Students',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Add new student logic here
                },
                icon: Icon(Icons.add),
                label: Text('Add Student'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('No.')),
                  DataColumn(label: Text('ID Number')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Action')),
                ],
                rows: List<DataRow>.generate(
                  students.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(students[index]['id']!)),
                      DataCell(Text(students[index]['name']!)),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            // Delete student logic here
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
