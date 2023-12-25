import 'package:debt_manager/controller/firebase_auth_services.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _textFieldUserController = TextEditingController();
  TextEditingController _textFieldPassController = TextEditingController();
  String _user = '';
  String _pass = '';
  bool _saveAccount = true;

  final FirebaseAuthService _auth = FirebaseAuthService();
  void _signUp() async {
    User? user = await _auth.signUpWithEmailAndPassword(_user, _pass);
    if(user != null) {
      Get.snackbar('Thông báo', 'Đăng ký thành công');
    }
    else {
      Get.snackbar('Thông báo', 'Đăng ký thật bại');
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
        hintText: 'Tên đăng nhập.....',
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
            backgroundColor: Color.fromARGB(255, 27, 199, 4)),
        onPressed: () {
          _signUp();

        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: prefer_const_constructors
            Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            SizedBox(
              height: 100,
              width: 10,
            ),
            Text(
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 15),
                'Đăng ký'),
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
      Text("Đã có tài khoản ?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),),
      TextButton(onPressed: (){
        Get.off(()=>const LoginPage());
      }, child: Text("Đăng nhập", style: TextStyle(fontSize: 15 , color: Color.fromARGB(255, 82, 113, 255))))
    ],);
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
                            color: Color.fromARGB(255, 27, 199, 4)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  username,
                  const SizedBox(height: 10.0),
                  password,
                  const SizedBox(height: 15.0),
                  loginButton,                
                  signup
                ],
              ),
            )));
  }
}
