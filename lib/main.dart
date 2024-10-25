import 'dart:io';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/features/app/spash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDTu-5AnoASrVxh2NONjOPcvP5Q7hhg1x8",
            appId: "1:171888820198:android:14f845ef6585cb20062027",
            messagingSenderId: "171888820198",
            projectId: "fbapptest1-e43aa"));
    await FirebaseAppCheck.instance.activate(      
      androidProvider: AndroidProvider.playIntegrity,
    );  
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDW0wo5NsW_M8BnRfEMwM2_Bas13FxvmDg",
            appId: "1:171888820198:web:39337b37bc16e0ba062027",
            messagingSenderId: "171888820198",
            projectId: "fbapptest1-e43aa"));
  }

  // Initialize GetX controller and load contacts
  final GlobalController c = Get.put(GlobalController());
  await c.loadContacts();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Pro App',
      home: SplashScreen());
  }
}
