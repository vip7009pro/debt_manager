import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/controller/firebase_auth_services.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/verification_page.dart';
import 'package:debt_manager/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalController c = Get.put(GlobalController());
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _textFieldUserController =
      TextEditingController();
  final TextEditingController _textFieldPassController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';
  String _errorMessage = '';
  String _otp = ''; 

  String _user = '';
  String _pass = '';
  bool _saveAccount = true;
  Future<void> _loadAccount() async {
    String savedUser = await LocalDataAccess.getVariable("user");
    String savedPass = await LocalDataAccess.getVariable("pass");
    setState(() {
      _user = savedUser;
      _pass = savedPass;
      _textFieldUserController.text = savedUser;
      _textFieldPassController.text = savedPass;
    });
  }

  Future<bool> _login(String email, String password) async {
    bool check = true;
    await API_Request.api_query('login', {
      'EMAIL': email,
      'PWD': GlobalFunction.generateMd5(password)
    }).then((value) {
      print("login");
      print(value);
      if (value['tk_status'] == 'OK') {
        print("login true");
        check = true;
        LocalDataAccess.saveVariable('token', value['token_content']);
        LocalDataAccess.saveVariable('userData', jsonEncode(value['data'][0]));
      } else {
        print("login false");
        check = false;
      }
    });
    return check;
  }

  Future<bool> _login_after_google(String uid, String email) async {
    bool check = true;
    await API_Request.api_query(
        'login_after_google', {'UID': uid, 'EMAIL': email}).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
        LocalDataAccess.saveVariable('token', value['token_content']);
        LocalDataAccess.saveVariable('userData', jsonEncode(value['data'][0]));
      } else {
        check = false;
      }
    });
    return check;
  }

  void _signInServer() async {
    bool checkserverLogin = await _login(_user, _pass);
    if (checkserverLogin) {
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
      // ignore: use_build_context_synchronously
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Cảnh báo',
        desc: 'Tên đăng nhập hoặc mật khẩu sai',
        btnCancelOnPress: () {},
        /* btnOkOnPress: () async {}, */
      ).show();
    }
  }

  void _signIn() async {
    User? user = await _auth.signInWithEmailAndPassword(_user, _pass);
    if (user != null) {
      bool checkserverLogin = await _login(user.uid, user.email!);
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
        Get.snackbar('Thông báo', 'Tài khoản chưa đồng bộ đăng ký',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5));
      }
    } else {}
  }

  void _signInWithGoogle() async {
    try {
      await c.googleSignIn().signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await c.googleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        final userDt = await _firebaseAuth.signInWithCredential(credential);
        bool checkserverLogin =
            await _login_after_google(userDt.user!.uid, userDt.user!.email!);
        if (checkserverLogin) {
          Get.snackbar('Thông báo',
              "Đăng nhập thành công: ${userDt.user?.displayName} ${userDt.user?.uid}  ${userDt.user?.email}",
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color.fromARGB(255, 173, 228, 168),
              colorText: const Color.fromARGB(255, 6, 16, 49),
              duration: const Duration(seconds: 5));
          await GlobalFunction.checkLogin();          
        } else {          
          String newPass = GlobalFunction.generateMd5('----------');
          await GlobalFunction.signUpServer(userDt.user!.uid, userDt.user!.email!, newPass);
          await _login(userDt.user!.email!, '----------');          
          await GlobalFunction.checkLogin();
        }
      }
    } catch (e) {
      String errorMessage = "Đã xảy ra lỗi khi đăng nhập bằng Google";
      if (e is PlatformException) {
        if (e.code == 'sign_in_failed') {
          errorMessage =
              "Đăng nhập thất bại. Vui lòng kiểm tra kết nối mạng và thử lại.";
        } else if (e.code == 'network_error') {
          errorMessage =
              "Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet của bạn.";
        }
      }
      Get.snackbar('Thông báo', errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5));
      if (kDebugMode) {
        print('Lỗi đăng nhập Google: ${e.toString()}');
      }
    }
  }

 Future<void> _verifyPhoneNumber() async {
    await _firebaseAuth.verifyPhoneNumber(
      
      phoneNumber: _textFieldUserController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
        // Đăng nhập thành công
        print("User logged in: ${_firebaseAuth.currentUser?.phoneNumber}");
      },
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed: ${e.message}');
        setState(() {
          _errorMessage = e.message!;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        print('code sent: $verificationId');
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('code auto retrieval timeout: $verificationId');
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _signInWithOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _firebaseAuth.signInWithCredential(credential);
      // Đăng nhập thành công
      print("User logged in: ${_firebaseAuth.currentUser?.phoneNumber}");
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
    }
  }

  Future<void> initFunction() async {
    await _loadAccount();
  }

  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
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
          _signInServer();
          //_signIn();
          //_signInWithGoogle();
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
            backgroundColor: const Color.fromARGB(255, 250, 0, 0)),
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

    // Đăng nhập bằng số điện thoại
    final phoneLoginButton = SizedBox(
      height: 50,
      width: 150,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 250, 0, 0)),
        onPressed: () {
          _verifyPhoneNumber();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, color: Colors.white, size: 30),
            SizedBox(height: 100, width: 10),
            Text(
              'Gửi mã OTP',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
    final otpInput = TextFormField(
      controller: _otpController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (term) {},
      onChanged: (value) => {_otp = value},
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Mã OTP',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    // Đăng nhập bằng mã OTP  
    final otpLoginButton = SizedBox(
      height: 50,
      width: 150,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 250, 0, 0)),
        onPressed: () {
          _signInWithOTP();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, color: Colors.white, size: 30),
            SizedBox(height: 100, width: 10),
            Text(
              'Đăng nhập bằng OTP',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
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
        const Text("Nhớ tài khoản")
      ],
    );
    final signup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Chưa có tài khoản ?",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextButton(
            onPressed: () {
              Get.to(() => const SignUpPage());
            },
            child: const Text("Đăng ký",
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
                  const SizedBox(height: 10),
                /*   phoneLoginButton,
                  const SizedBox(height: 10),
                  otpInput,
                  const SizedBox(height: 10), 
                  otpLoginButton,
                  const SizedBox(height: 10),  */
                  saveID,
                  signup
                ],
              ),
            )));
  }
}
