import 'dart:convert';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/coupons_screen.dart';
import 'package:debt_manager/pages/create_invoice_screen.dart';
import 'package:debt_manager/pages/drawer_header.dart';
import 'package:debt_manager/pages/invoice_screen.dart';
import 'package:debt_manager/pages/more_options_screen.dart';
import 'package:debt_manager/pages/products_screen.dart';
import 'package:debt_manager/pages/report_screen.dart';
import 'package:debt_manager/pages/shop_info_screen.dart';
import 'package:debt_manager/pages/shop_list_screen.dart';
import 'package:debt_manager/pages/stock_screen.dart';
import 'package:debt_manager/pages/supplier_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedBottomIndex = 0;
  final GlobalController c = Get.put(GlobalController());
  Shop shop = Shop(
      shopId: 0,
      uid: '',
      shopName: '',
      shopDescr: '',
      shopAdd: '',
      insDate: DateTime.now(),
      insUid: '',
      updDate: DateTime.now(),
      updUid: '',
      shopAvatar: '');

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

  Future<void> _getShopInfo() async {
    List<dynamic> shopList = [];
    await API_Request.api_query('getShopInfo', {
      'SHOP_ID': c.shopID.value == ''
          ? await LocalDataAccess.getVariable('shopid')
          : c.shopID.value
    }).then((value) {
      shopList = value['data'] ?? [];
      setState(() {
        if (shopList.isNotEmpty) {
          shop = Shop.fromJson(shopList[0]);
        }
      });
    });
  }

  void _loadshopidfromlocaldatabse () async {
    c.shopID.value = await LocalDataAccess.getVariable('shopid');
  } 
  @override
  void initState() {
      _loadshopidfromlocaldatabse();
      _getShopInfo();
    super.initState();
  }

  Widget _buildFunctionWidget(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.indigo),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsWidget(IconData icon, String title, String amount) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 30, color: Colors.teal),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.teal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: GestureDetector(
        onTap: () {
          Get.to(() => const ShopInfoScreen());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                "http://192.168.1.136/shop_avatars/${shop.shopId}.jpg",
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey[300],
                    child: Icon(Icons.store, color: Colors.grey[600]),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.shopName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  shop.shopDescr,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.teal,
      flexibleSpace: Container(),
    );
    
    final bannerWidget = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: PageView.builder(        
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(            
            decoration: BoxDecoration(
              color: Colors.teal[100 * (index + 1)],
              borderRadius: BorderRadius.circular(10),              
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/banner_${index + 1}.png',
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Banner ${index + 1}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    final drawer = Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white, 
                  Colors.tealAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
            ),
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0), 
            child: DrawerHeaderTab(),
          ),
          ExpansionTile(
            title: const Text("Quản lý cửa hàng", style: TextStyle(color: Colors.teal)),
            leading: const Icon(
              Icons.shopping_bag,
              color: Colors.teal,
            ),  
            childrenPadding: const EdgeInsets.only(left: 10),
            children: [
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                leading: const FaIcon(
                  FontAwesomeIcons.list,
                  color: Colors.teal,
                ),
                title: const Text("Danh sách cửa hàng", style: TextStyle(color: Colors.teal)),  
                onTap: () {
                  Get.to(() => const ShopListScreen());
                },
              ),
            ],
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -3),
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
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
    );
    
    final functionWidget = Center(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,     
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.1),       
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2), 
            ),
          ],
        ),  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFunctionWidget(Icons.receipt, "Create invoice", () => Get.to(() => const CreateInvoiceScreen())),
                _buildFunctionWidget(Icons.description, "Invoice", () => Get.to(() => const InvoiceScreen())),
                _buildFunctionWidget(Icons.inventory, "Products", () => Get.to(() => const ProductsScreen())),
                _buildFunctionWidget(Icons.local_offer, "Coupons", () => Get.to(() => const CouponsScreen())),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFunctionWidget(Icons.storage, "Stock", () => Get.to(() => const StockScreen())),
                _buildFunctionWidget(Icons.bar_chart, "Report", () => Get.to(() => const ReportScreen())),
                _buildFunctionWidget(Icons.people, "Supplier", () => Get.to(() => const SupplierScreen())),
                _buildFunctionWidget(Icons.more_horiz, "More...", () => Get.to(() => const MoreOptionsScreen())),
              ],
            ),
          ],
        ),
      ),
    );

    final statsWidget = Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatsWidget(Icons.shopping_cart, "PO", "1,234"),
          _buildStatsWidget(Icons.attach_money, "Revenue", "\$5,678"),
          _buildStatsWidget(Icons.trending_up, "Profit", "\$2,345"),
        ],
      ),
    );

    final orderStatusWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,          
            children: [
              const Text(
                "Order Status",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement show detail functionality
                },
                child: const Text("Show Detail", style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.hourglass_empty, size: 30, color: Colors.orange),
                   Text(
                    "Waiting",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.orange),
                  ),
                   Text(
                    "5",  // Replace with actual number
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.sync, size: 30, color: Colors.teal),
                   Text(
                    "Processing",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.teal),
                  ),
                   Text(
                    "3",  // Replace with actual number
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      extendBodyBehindAppBar: true,
      appBar: appBar,       
      backgroundColor: Colors.white,
      drawer: drawer,
        body: Column(
        children: [          
          Expanded(
            child: Container(              
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.teal,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Add your refresh logic here
                      // For example, you might want to reload data or update state
                      _getShopInfo();
                      setState(() {
                        // Update your state or reload data
                      // Refresh network images
                      setState(() {
                        // Force rebuild of network images
                        imageCache.clear();
                        imageCache.clearLiveImages();
                      });
                      });
                    },
                    child: ListView(                    
                      children: [
                        const SizedBox(height: 16),
                        bannerWidget,
                        const SizedBox(height: 16),
                        statsWidget,
                        const SizedBox(height: 16),
                        functionWidget,
                        const SizedBox(height: 16),
                        orderStatusWidget,
                        const SizedBox(height: 16),                     
                       
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.teal,
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: Colors.white,
        onTap: _onBottomItemTapped,
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
            backgroundColor: Colors.teal,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            });
      }),
    );
  }
}