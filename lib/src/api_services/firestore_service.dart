import 'dart:developer';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive list to hold attendance records
  var attendanceRecords = <Map<String, dynamic>>[].obs;

  // Reactive map to hold user data
  var userData = {}.obs;

  // Reactive list to hold student data
  var studentData = <Map<String, dynamic>>[].obs;

  // Reactive list to hold student attendance records
  var studentAttendanceRecords = <Map<String, dynamic>>[].obs;

  // Method to fetch user data
  Future<void> fetchUserData(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(documentId).get();
      if (documentSnapshot.exists) {
        userData.value = documentSnapshot.data() as Map<String, dynamic>;
      } else {
        log("No document found with ID: $documentId");
      }
    } catch (e) {
      log("Error fetching user data: $e");
    }
  }

  // Method to fetch all students from Firestore
  Future<void> getAllStudent() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('students').get();
      studentData.value = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'fullname': doc['fullname'],
          'idnumber': doc['idnumber'],
          'section': doc['section'],
        };
      }).toList();
    } catch (e) {
      log("Error fetching students: $e");
      studentData.clear();
    }
  }

  // Method to retrieve or create an attendance document ID
  Future<String> getOrCreateAttendanceId({
    required String userId,
    required DateTime date,
    required String section,
    required String subject,
  }) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .where('date', isEqualTo: date)
          .where('subject', isEqualTo: subject)
          .where('section', isEqualTo: section)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.id;
      } else {
        DocumentReference docRef = await _firestore
            .collection('users')
            .doc(userId)
            .collection('attendance')
            .add({
          'date': date,
          'section': section,
          'subject': subject,
          'timestamp': FieldValue.serverTimestamp(),
        });
        return docRef.id;
      }
    } catch (e) {
      log('Error retrieving or creating attendance document: $e');
      rethrow;
    }
  }

  // Method to store an attendance record in a specific attendance document's record subcollection
  Future<void> storeAttendanceRecord({
    required String userId,
    required String attendanceId,
    required String recordId,
    required String fullname,
    required String idnumber,
    required String section,
    required String subject,
    required DateTime date,
    required bool isAbsent,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .doc(attendanceId)
          .collection('record')
          .doc(recordId)
          .set({
        'fullname': fullname,
        'idnumber': idnumber,
        'section': section,
        'subject': subject,
        'date': date,
        'isAbsent': isAbsent,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Attendance record saved successfully!',
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong!',
          snackPosition: SnackPosition.TOP);
    }
  }

  // Method to retrieve attendance records for a specific user
  Future<void> retrieveAttendance({required String userId}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> records = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'date': (doc['date'] as Timestamp).toDate(),
          'section': doc['section'],
          'subject': doc['subject'],
          'timestamp': (doc['timestamp'] as Timestamp).toDate(),
        };
      }).toList();
      attendanceRecords.value = records;
    } catch (e) {
      log('Error retrieving attendance: $e');
      attendanceRecords.clear();
    }
  }

  // Method to retrieve records within a specific attendance document's record subcollection
  Future<void> retrieveAttendanceRecord({
    required String userId,
    required String attendanceId,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .doc(attendanceId)
          .collection('record')
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> records = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'fullname': doc['fullname'],
          'idnumber': doc['idnumber'],
          'section': doc['section'],
          'subject': doc['subject'],
          'isAbsent': doc['isAbsent'],
          'timestamp': (doc['timestamp'] as Timestamp).toDate(),
        };
      }).toList();

      studentAttendanceRecords.value = records;
    } catch (e) {
      log('Error retrieving attendance record: $e');
      studentAttendanceRecords.clear();
    }
  }

  // Method to delete an attendance record
  Future<void> deleteAttendanceRecord({
    required String userId,
    required String attendanceId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .doc(attendanceId)
          .delete();

      Get.snackbar('Success', 'Attendance record deleted!',
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete attendance record',
          snackPosition: SnackPosition.TOP);
      log("Error deleting attendance record: $e");
    }
  }

  void storeAttendance(
      {required String userId,
      required DateTime date,
      required String section,
      required String subject}) {}
}
