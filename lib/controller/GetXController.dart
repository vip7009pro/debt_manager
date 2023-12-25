import 'package:get/get.dart';

class GlobalController extends GetxController {
  var count = 0.obs;
  increment() {
    count++;
  }

  decrement() {
    count--;
  }

  String serverIP = 'http:/14.160.33.94:3007/api';
  void changeServerIP(String newIP) {
    serverIP = newIP;
  }

  String loggedinUser = '';
  void changeLoggedInUser(String newUser) {
    loggedinUser = newUser;
  }
}
