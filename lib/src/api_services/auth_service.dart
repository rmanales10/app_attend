import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;

  // Register user with Firebase Auth and store in Firestore
  Future<void> registerUser(
      String fullname, String email, String password, String phone) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Save user information to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullname': fullname.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Account created successfully!',
          snackPosition: SnackPosition.TOP);
      Get.toNamed('/login'); // Navigate to the login page
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  // Login user with Firebase Auth
  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      Get.snackbar('Success', 'Logged in successfully!',
          snackPosition: SnackPosition.TOP);
      Get.offAllNamed('/dashboard'); // Navigate to the dashboard page
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.snackbar('Success', 'User Logged out successfully!',
        snackPosition: SnackPosition.TOP);
    Get.offAllNamed('/welcome'); // Navigate to the dashboard page
  }
}
