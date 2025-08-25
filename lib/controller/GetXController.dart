import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class GlobalController extends GetxController {
  var googleSignIn = GoogleSignIn(signInOption: SignInOption.standard).obs;
  var count = 0.obs;
  var shopID = 0.obs;

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

  RxList<Contact> contacts = <Contact>[].obs;
  RxBool isContactsLoaded = false.obs;

  Future<void> loadContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final allContacts = await FlutterContacts.getContacts(withProperties: true);
      contacts.value = allContacts.where((contact) => contact.phones.isNotEmpty).toList();
      isContactsLoaded.value = true;
    }
  }
}
