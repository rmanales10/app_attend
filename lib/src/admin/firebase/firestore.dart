import 'dart:developer';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list of users
  RxList<Map<String, dynamic>> allUsers = <Map<String, dynamic>>[].obs;

  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      allUsers.value = querySnapshot.docs.map((doc) {
        // Include the document ID in the user data
        Map<String, dynamic> user = doc.data() as Map<String, dynamic>;
        user['id'] = doc.id;
        return user;
      }).toList();
    } catch (e) {
      log("Error fetching users: $e");
    }
  }

  Future<void> deleteUser(String? id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
      // Remove the user from the local list
      allUsers.removeWhere((user) => user['id'] == id);
    } catch (e) {
      log("Error deleting user: $e");
    }
  }
}
