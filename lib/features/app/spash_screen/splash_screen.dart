import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/controller/firebase_auth_services.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/verification_page.dart';
import 'package:debt_manager/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  String _user = '';
  String _pass = '';
  bool _saveAccount = true;
Future<void> _loadAccount() async{
  String savedUser = await LocalDataAccess.getVariable("user");
  String savedPass = await LocalDataAccess.getVariable("pass");  
  setState(() {
    _user = savedUser;
    _pass = savedPass;
    _textFieldUserController.text = savedUser;
    _textFieldPassController.text = savedPass;
  });
}
  Future<bool> _checkLogin(String uid, String email) async {
    bool check = true;
    await API_Request.api_query('login', {
      'EMAIL': email,
      'UID': uid
    }).then((value) {     
      if (value['tk_status'] == 'OK') {
        check = true;
        LocalDataAccess.saveVariable('token', value['token_content']); 
        LocalDataAccess.saveVariable('userData',jsonEncode(value['data'][0]) ); 
      } else {
        check = false;
      }
    });
    return check;
  }
  void _signIn() async {
    User? user = await _auth.signInWithEmailAndPassword(_user, _pass);
    if (user != null) {
      bool checkserverLogin = await _checkLogin(user.uid, user.email!);
      if (checkserverLogin) {
        if (user.emailVerified) {
          //Get.snackbar('Thông báo', 'Đăng nhập thành công cho : ${user.uid}');
          if (_saveAccount) {
            LocalDataAccess.saveVariable('user', _user);
            LocalDataAccess.saveVariable('pass', _pass);
          } else {
            LocalDataAccess.saveVariable('user', '');
            LocalDataAccess.saveVariable('pass', '');
          }
          Get.off(() => const HomePage());
        } else {
          Get.to(() => const VerificationPage());
        }
      } else {
        Get.snackbar("Thông báo",
            'Tài khoản chưa đồng bộ, hãy thử đăng nhập với google nếu bạn dùng gmail');
        Get.off(() => const LoginPage());
      }
    } else {}
  }
  
  void _signInWithGoogle() async { 
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await c.googleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;            
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        final userDt = await _firebaseAuth.signInWithCredential(credential);
        bool checkserverLogin = await _checkLogin(userDt.user!.uid,userDt.user!.email!);
        if(checkserverLogin) {
          Get.snackbar('Thông báo', "Đăng nhập thành công: ${userDt.user?.displayName} ${userDt.user?.uid}  ${userDt.user?.email}");
          Get.off(() => const HomePage()); 
        }
        else {
          GlobalFunction.signUpServer(userDt.user!.uid, userDt.user!.email!,'----------');
          Get.off(() => const HomePage()); 
          //Get.snackbar("Thông báo", 'Tài khoản chưa đồng bộ đăng ký');
        }
      }
    } catch (e) {
      Get.snackbar('Thông báo', "Lỗi: ${e.toString()}");
      if (kDebugMode) {
        print('Thông báo ' "Lỗi: ${e.toString()}");
      }
    }
  }
  Future<void> initFunction() async {
     await _loadAccount();
     String savedToken = await LocalDataAccess.getVariable("token");    
     if(savedToken !='reset') {
      _signIn();
      print('co token');
     }
     else {
      Get.off(()=>const LoginPage());
      print('khong co token');
     }
  }
  @override
  void initState() {
    // TODO: implement initState
    initFunction();
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