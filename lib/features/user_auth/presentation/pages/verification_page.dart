import 'dart:async';

import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({ Key? key }) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
   late Timer _timer;
   final GlobalController c = Get.put(GlobalController());

 Future<void> checkVerification() async {
  var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      if(user!.emailVerified) {
        Get.off(()=> HomePage());
      }
      else {

      }
      
      //Get.snackbar("Thông báo", "user verified status: ${user?.emailVerified}");
    } else {}
 }
   @override
  void initState() {     
    checkVerification();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkVerification();     
    });
   
    super.initState();
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child:Scaffold(body: Center(
        child: Text("Please check your email for verification !",style: TextStyle(color: Colors.black, fontSize: 30),),
      ),)
        
      
    );
  }
}