import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/firebase_auth_services.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/verification_page.dart';
import 'package:debt_manager/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final GlobalController c = Get.put(GlobalController());
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _textFieldUserController = TextEditingController();
  final TextEditingController _textFieldPassController = TextEditingController();
  String _user = '';
  String _pass = '';
  bool _saveAccount = true;
  void _signIn() async {
    User? user = await _auth.signInWithEmailAndPassword(_user, _pass);
    if (user != null) {
      if(user.emailVerified) {
        Get.snackbar('Thông báo', 'Đăng nhập thành công cho : ${user.uid}');      
        Get.off(() => const HomePage());
      }
      else {
        Get.to(()=> VerificationPage());
      }
    } else {
      //Get.snackbar('Thông báo', 'Đăng nhập thật bại');
    }
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
        Get.snackbar('Thông báo', "Đăng nhập thành công: ${userDt.user?.displayName} ${userDt.user?.uid}  ${userDt.user?.email}");
        Get.off(() => const HomePage()); 
      }
    } catch (e) {
      Get.snackbar('Thông báo', "Lỗi: ${e.toString()}");
      if (kDebugMode) {
        print('Thông báo ' "Lỗi: ${e.toString()}");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/app_logo.png',
      width: 150,
      height: 150,
    );
    final username = TextFormField(
      controller: _textFieldUserController,
      textInputAction: TextInputAction.next,
      onChanged: (value) => {_user = value},
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email.....',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password = TextFormField(
      controller: _textFieldPassController,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (term) {},
      onChanged: (value) => {_pass = value},
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final loginButton = SizedBox(
      height: 50,
      width: 150,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 82, 113, 255)),
        onPressed: () {
          _signIn();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: prefer_const_constructors
            Icon(
              Icons.login,
              color: Colors.white,
            ),
            SizedBox(
              height: 100,
              width: 10,
            ),
            Text(
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 15),
                'Đăng nhập'),
          ],
        ),
      ),
    );
    final googleLoginButton = SizedBox(
      height: 50,
      width: 150,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 250, 0, 0)),
        onPressed: () {
          _signInWithGoogle();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: prefer_const_constructors
            Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
            SizedBox(
              height: 100,
              width: 10,
            ),
            Text(
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 15),
                'Đăng nhập bằng google'),
          ],
        ),
      ),
    );
    final saveID = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: _saveAccount,
            onChanged: (value) {
              setState(() {
                _saveAccount = value!;
              });
            }),
        Text("Nhớ tài khoản")
      ],
    );
    final signup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Chưa có tài khoản ?",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextButton(
            onPressed: () {
              Get.to(() => const SignUpPage());
            },
            child: Text("Đăng ký",
                style: TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 82, 113, 255))))
      ],
    );
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                children: [
                  logo,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Shop Pro",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color.fromARGB(1000, 82, 113, 255)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  username,
                  const SizedBox(height: 10.0),
                  password,
                  const SizedBox(height: 15.0),
                  loginButton,
                  const SizedBox(
                    height: 10,
                  ),
                  googleLoginButton,
                  saveID,
                  signup
                ],
              ),
            )));
  }
}
