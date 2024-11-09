import 'package:app_attend/src/dashboard/list_screen/create_attendance.dart';
import 'package:app_attend/src/widgets/reusable_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'List of Attendance',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => CreateAttendance()),
                      child:
                          Row(children: [Icon(Icons.add), Text('Create New')]),
                    ))),
            lineSpacer(size),
            createCard('IT312 Software Engineering -BSIT - 1B'),
            createCard('IT312 Software Engineering -BSIT - 1A'),
          ],
        ),
      ),
    );
  }

  Container createCard(String label) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.5),
        border: Border.all(color: Colors.black, width: .8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete))
        ],
      ),
    );
  }
}
