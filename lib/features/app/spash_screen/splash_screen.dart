import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/controller/firebase_auth_services.dart';
import 'package:debt_manager/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  
  const SplashScreen({ Key? key, }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalController c = Get.put(GlobalController());
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _textFieldUserController = TextEditingController();
  final TextEditingController _textFieldPassController = TextEditingController();
  final String _user = '';
  final String _pass = '';
  final bool _saveAccount = true;

  Future<bool> _checkLogin() async {
    bool check = true;
    await API_Request.api_query('checklogin', {}).then((value) {      
      if (value['tk_status'] == 'OK') {
        check = true;
        LocalDataAccess.saveVariable('userData', jsonEncode(value['data']));
        Get.off(() => const HomePage());        
      } else {
        check = false;
        Get.off(() => const LoginPage());
      }
    });
    return check;
  }  

  @override
  void initState() {  
    _checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:  Text("SHOP PRO", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),),
      ),
      
    );
  }
}