import 'dart:io';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/features/app/spash_screen/splash_screen.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDTu-5AnoASrVxh2NONjOPcvP5Q7hhg1x8",
            appId: "1:171888820198:android:14f845ef6585cb20062027",
            messagingSenderId: "171888820198",
            projectId: "fbapptest1-e43aa"));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDW0wo5NsW_M8BnRfEMwM2_Bas13FxvmDg",
            appId: "1:171888820198:web:39337b37bc16e0ba062027",
            messagingSenderId: "171888820198",
            projectId: "fbapptest1-e43aa"));
  }
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final GlobalController c = Get.put(GlobalController());
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Pro App',
      home: SplashScreen());
  }
}