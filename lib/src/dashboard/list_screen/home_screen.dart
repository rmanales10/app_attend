import 'package:app_attend/src/widgets/color_constant.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedValue = "Option 1";
  List<String> items = [
    "Option 1",
    "Option 2",
    "Option 3",
    "Option 4",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 4, 4, 3),
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://static1.srcdn.com/wordpress/wp-content/uploads/2024/10/untitled-design-2024-10-01t123706-515-1.jpg'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RichText(
                          text: TextSpan(
                        text: 'Beshy Ko\n',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'Instructor',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(onPressed: () {}, child: Text('Tap to Attend')),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectList(),
                selectList(),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                totalStudentCard(
                    'Student Present', 'assets/present.png', '200'),
                totalStudentCard(
                    'Student Absent', 'assets/studentabsent.png', '2'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container totalStudentCard(String label, String image, String total) {
    return Container(
      width: 150,
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(image),
                  width: 60,
                ),
                Text(
                  total,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.7)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container selectList() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        underline: SizedBox(),
        style: const TextStyle(
          color: Colors.black,
        ),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
      ),
    );
  }
}
