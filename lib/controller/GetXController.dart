import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GlobalController extends GetxController {
  var googleSignIn = GoogleSignIn(signInOption: SignInOption.standard).obs;
  var count = 0.obs;
  var shopID = ''.obs;
  increment() {
    count++;
  }

  decrement() {
    count--;
  }

  String serverIP = 'http:/14.160.33.94:3009/api';
  void changeServerIP(String newIP) {
    serverIP = newIP;
  }

  String loggedinUser = '';
  void changeLoggedInUser(String newUser) {
    loggedinUser = newUser;
  }
}
