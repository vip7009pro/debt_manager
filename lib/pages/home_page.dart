import 'dart:convert';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:debt_manager/pages/drawer_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedBottomIndex = 0;
  final GlobalController c = Get.put(GlobalController());
  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });
  }
  final logo =
      Image.asset('assets/images/app_logo.png', width: 120, fit: BoxFit.cover);
  int mobileVer = 4;
  late Timer _timer;
  Future<bool> _checkLogin(String uid, String email) async {
    bool check = true;
    await API_Request.api_query('login', {'EMAIL': email, 'UID': uid})
        .then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
        LocalDataAccess.saveVariable('token', value['token_content']);
        LocalDataAccess.saveVariable('userData', jsonEncode(value['data'][0]));
        var response = value['data'][0];
        print(response);
        setState(() {});
      } else {
        check = false;
      }
    });
    return check;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: Row(
            children: [
              const Text(
                "Home",
              ),
              Text(
                "Ver: ${mobileVer}",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
              /*  decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(0, 133, 196, 248),
                    Color.fromARGB(0, 0, 140, 255),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ), */
              )),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 193, 228, 244),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: DrawerHeaderTab()),
            ExpansionTile(
              title: const Text("Quản lý cửa hàng"),
              leading: const Icon(
                Icons.shopping_bag,
                color: Color.fromARGB(255, 59, 130, 236),
              ), //add icon
              childrenPadding:
                  const EdgeInsets.only(left: 10), //children padding
              children: [
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const FaIcon(
                    FontAwesomeIcons.list,
                    color: Colors.green,
                  ),
                  title: const Text("Danh sách cửa hàng"),
                  onTap: () {
                    //action on press
                    //Get.to(() => const DiemDanhNhom());
                  },
                ),
                //more child menu
              ],
            ),
            ListTile(
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              title: const Text("Logout"),
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.rightSlide,
                  title: 'Cảnh báo',
                  desc: 'Bạn muốn logout?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    try {
                      /* await FirebaseAuth.instance.signOut();
                      c.googleSignIn().disconnect(); */
                      GlobalFunction.logout();
                      Get.off(() => const LoginPage());
                    } catch (e) {
                      Get.snackbar("Thông báo", "Lỗi: ${e.toString()}");
                    }
                  },
                ).show();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 93, 192, 231),
            Color.fromARGB(255, 241, 241, 241),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      debugPrint('password has been changed');
                      await user.reload();
                      user = FirebaseAuth.instance.currentUser;
                      await user?.updatePassword("147258369");
                    } else {
                      debugPrint("password hasnt been changed");
                      // No user is signed in.
                    }
                  } catch (e) {
                    Get.snackbar("Thông báo", e.toString());
                  }
                },
                child: const Text("Change Password")),
            ElevatedButton(
                onPressed: () async {
                  var user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.reload();
                    user = FirebaseAuth.instance.currentUser;
                    Get.snackbar("Thông báo",
                        "user verified status: ${user?.emailVerified}");
                  } else {}
                },
                child: const Text("Check email")),
            ElevatedButton(
                onPressed: () async {
                  var user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.reload();
                    _checkLogin(user.uid, user.email!);
                  } else {}
                },
                child: const Text("Login test")),
          ],
        )),
        /* child: Obx(() =>  Container(
          height: double.infinity,
          width: double.infinity,
          child: HomeWidget())
          ), */
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 100, 167, 191),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: Color.fromARGB(255, 252, 238, 34),
        onTap: _onBottomItemTapped,
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 207, 217, 236),
            child: Icon(Icons.add),
            onPressed: () {
              //tryOtaUpdate();
              Scaffold.of(context).openDrawer(); // <-- Opens drawer.
            });
      }),
    );
  }
}
