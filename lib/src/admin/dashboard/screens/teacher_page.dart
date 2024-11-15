import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                'Employee Leave Table',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 150),
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
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('No.')),
                      DataColumn(label: Text('Fullname')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone Number')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('21918')),
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Anugrah Prasetya'),
                            Text('Graphic Designer',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        )),
                        DataCell(Text('24 - 25 July')),
                        DataCell(Text('24 Hours')),
                        DataCell(Text('Sick leave')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('37189')),
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Denny Malik'),
                            Text('IT Support',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        )),
                        DataCell(Text('22 - 24 August')),
                        DataCell(Text('2 Days')),
                        DataCell(Text('Annual leave')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('41521')),
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Silvia Cintia Bakri'),
                            Text('Product Designer',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        )),
                        DataCell(Text('01 - 30 August')),
                        DataCell(Text('30 Days')),
                        DataCell(Text('Maternity leave')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('12781')),
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bambang Pramudi'),
                            Text('Customer Support',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        )),
                        DataCell(Text('20 - 30 August')),
                        DataCell(Text('10 Days')),
                        DataCell(Text('Paternity leave')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('81721')),
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Joseph Stewart'),
                            Text('Mobile Developer',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        )),
                        DataCell(Text('29 August')),
                        DataCell(Text('12 Hours')),
                        DataCell(Text('Half-day leave')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('09172')),
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Putri Candra Alexa'),
                            Text('Web Developer',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        )),
                        DataCell(Text('23 - 24 July')),
                        DataCell(Text('2 Days')),
                        DataCell(Text('Bereavement leave')),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
