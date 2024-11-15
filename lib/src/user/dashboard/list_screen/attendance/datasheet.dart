import 'package:app_attend/src/user/widgets/attendance_sheet.dart';
import 'package:flutter/material.dart';

class Datasheet extends StatelessWidget {
  const Datasheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AttendanceSheet(),
    );
  }
}
