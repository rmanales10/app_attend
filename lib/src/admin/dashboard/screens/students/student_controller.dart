import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addStudent({
    required String name,
    required String yearLevel,
    required String section,
  }) async {
    await _firestore.collection('students').add({
      'name': name,
      'year_level': yearLevel,
      'section': section,
    });
  }

  RxList<Map<String, dynamic>> allStudents = <Map<String, dynamic>>[].obs;
  Future<void> getAllStudents() async {
    QuerySnapshot querySnapshot = await _firestore.collection('students').get();

    allStudents.value = querySnapshot.docs
        .map((doc) => {
              'name': doc['name'],
              'year_level': doc['year_level'],
              'section': doc['section'],
            })
        .toList();
  }
}
