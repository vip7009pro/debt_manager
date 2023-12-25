import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({ Key? key, this.child }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalController c = Get.put(GlobalController());  
  
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1), () {
        Get.off(() =>  const LoginPage());
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> widget.child!), (route) => false);
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:  Text("So ghi no", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),),
      ),
      
    );
  }
}