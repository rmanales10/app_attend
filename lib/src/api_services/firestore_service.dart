import 'dart:developer';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var attendanceRecords = <Map<String, dynamic>>[].obs;

  var userData = {}.obs;

  var studentData = <Map<String, dynamic>>[].obs;

  var studentAttendanceRecords = <Map<String, dynamic>>[].obs;

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

  Future<void> getStudentAttendanceStatus({
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
          .get();

      for (var doc in querySnapshot.docs) {
        studentAttendanceRecords.add({
          'id': doc.id,
          'isAbsent': doc['isAbsent'] ?? true,
        });
      }
    } catch (e) {
      log('Error fetching student attendance status: $e');
    }
  }

  Future<Map<String, int>> getAttendanceCounts({
    required String userId,
    required String attendanceId,
  }) async {
    RxInt presentCount = 0.obs;
    RxInt absentCount = 0.obs;
    RxInt total = 0.obs;

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .doc(attendanceId)
          .collection('record')
          .get();

      for (var doc in querySnapshot.docs) {
        bool isAbsent = doc['isAbsent'] ?? true; // Default to absent if not set
        total.value++;
        if (isAbsent) {
          absentCount.value++;
        } else {
          presentCount.value++;
        }
      }
    } catch (e) {
      log('Error fetching attendance counts: $e');
    }

    return {
      'presentCount': presentCount.value,
      'total': total.value,
      'absentCount': absentCount.value
    };
  }

  var sections = <String>[].obs;
  var subjects = <String>[].obs;

  Future<void> fetchSectionsAndSubjects({required String userId}) async {
    QuerySnapshot querySnapshotSection = await _firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .get();
    sections.value = querySnapshotSection.docs
        .map((doc) => doc['section'] as String)
        .toSet()
        .toList();

    QuerySnapshot querySnapshotSubject = await _firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .get();

    subjects.value = querySnapshotSubject.docs
        .map((doc) => doc['subject'] as String)
        .toSet()
        .toList();
  }
}
