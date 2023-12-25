import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
   Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        Get.snackbar('Thông báo', 'Có lỗi:  The email address is already in use.',
              duration: const Duration(seconds: 2));       
      } else {        
        Get.snackbar('Thông báo', 'Có lỗi:  ${e.code}',
              duration: const Duration(seconds: 2));
      }
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Get.snackbar('Thông báo', 'Có lỗi:  Invalid email or password.',
              duration: const Duration(seconds: 2));
       
      } else {        
         Get.snackbar('Thông báo', 'Có lỗi:  ${e.code}',
              duration: const Duration(seconds: 2));
      }

    }
    return null;

  }


}