import 'dart:convert';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/coupons/coupons_screen.dart';
import 'package:debt_manager/pages/customers/customer_screen.dart';
import 'package:debt_manager/pages/invoices/create_invoice_screen.dart';
import 'package:debt_manager/pages/customers/add_customers_screen.dart';
import 'package:debt_manager/pages/drawer_header.dart';
import 'package:debt_manager/pages/invoices/invoice_screen.dart';
import 'package:debt_manager/pages/more_options/more_options_screen.dart';
import 'package:debt_manager/pages/orders/add_orders_screen.dart';
import 'package:debt_manager/pages/orders/orders_screen.dart';
import 'package:debt_manager/pages/products/add_products_screen.dart';
import 'package:debt_manager/pages/products/products_screen.dart';
import 'package:debt_manager/pages/reports/report_screen.dart';
import 'package:debt_manager/pages/shops/shop_info_screen.dart';
import 'package:debt_manager/pages/shops/shop_list_screen.dart';
import 'package:debt_manager/pages/stocks/stock_screen.dart';
import 'package:debt_manager/pages/stocks/warehouse_screen.dart';
import 'package:debt_manager/pages/suppliers/supplier_screen.dart';
import 'package:debt_manager/pages/suppliers/add_suppliers_screen.dart';
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
          ? await LocalDataAccess.getVariable('shopId')
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
  void _loadshopidfromlocaldatabse() async {
    String shopId = await LocalDataAccess.getVariable('shopId');
    c.shopID.value = shopId;
    print('c.shopID.value' + shopId);
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
          borderRadius: BorderRadius.circular(5),
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
        borderRadius: BorderRadius.circular(5),
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
            child: Icon(icon,
                size: 30, color: const Color.fromARGB(255, 42, 97, 199)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 97, 199)),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 42, 97, 199)),
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
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "http://14.160.33.94:3010/shop_avatars/${shop.shopId}.jpg",
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  shop.shopDescr,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.lightBlue,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.lightBlueAccent],
          ),
        ),
      ),
    );
    final bannerWidget = SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 100,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 250, 249),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    'http://14.160.33.94:3010/shop_avatars/banner.jpg',
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.1,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                  Text(
                    'Banner ${index + 1}',
                    style: const TextStyle(
                        fontSize: 10, color: Color.fromARGB(255, 48, 44, 44)),
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
          const SizedBox(
            height: 100, //fit child content height,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFE1F5FE), // Light blue
                      Color.fromARGB(255, 159, 222, 252), // Darker blue
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.0, 0.5),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: DrawerHeaderTab(),
            ),
          ),
          ExpansionTile(
            title: const Text("Quản lý cửa hàng",
                style: TextStyle(color: Colors.lightBlue)),
            leading: const Icon(
              Icons.shopping_bag,
              color: Colors.lightBlue,
            ),
            childrenPadding: const EdgeInsets.only(left: 10),
            children: [
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                leading: const FaIcon(
                  FontAwesomeIcons.list,
                  color: Colors.lightBlue,
                ),
                title: const Text("Danh sách cửa hàng",
                    style: TextStyle(color: Colors.lightBlue)),
                onTap: () {
                  Get.to(() => const ShopListScreen());
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Quản lý nhân viên",
                style: TextStyle(color: Colors.lightBlue)),
            leading: const Icon(
              Icons.people,
              color: Colors.lightBlue,
            ),
            childrenPadding: const EdgeInsets.only(left: 10),
            children: [
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                leading: const FaIcon(
                  FontAwesomeIcons.list,
                  color: Colors.lightBlue,
                ),
                title: const Text("Danh sách nhân viên",
                    style: TextStyle(color: Colors.lightBlue)),
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
        height: 300,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 251, 255, 255).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
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
                _buildFunctionWidget(Icons.receipt, "PO",
                    () => Get.to(() => const OrdersScreen())),
                _buildFunctionWidget(Icons.description, "Invoice",
                    () => Get.to(() => const InvoiceScreen())),
                _buildFunctionWidget(Icons.inventory, "Products",
                    () => Get.to(() => const ProductsScreen())),
                _buildFunctionWidget(Icons.local_offer, "Coupons",
                    () => Get.to(() => const CouponsScreen())),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFunctionWidget(Icons.storage, "Stock",
                    () => Get.to(() => const StockScreen())),
                _buildFunctionWidget(Icons.warehouse, "Warehouse",
                    () => Get.to(() => const WarehouseScreen())),
                _buildFunctionWidget(Icons.people, "Supplier",
                    () => Get.to(() => const SupplierScreen())),
                _buildFunctionWidget(Icons.person, "Customers",
                    () => Get.to(() => const CustomerScreen())),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFunctionWidget(Icons.storage, "Stock",
                    () => Get.to(() => const StockScreen())),
                _buildFunctionWidget(Icons.bar_chart, "Report",
                    () => Get.to(() => const ReportScreen())),
                _buildFunctionWidget(Icons.people, "Supplier",
                    () => Get.to(() => const SupplierScreen())),
                _buildFunctionWidget(Icons.more_horiz, "More...",
                    () => Get.to(() => const MoreOptionsScreen())),
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
        color: const Color(0xFFE1F5FE).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF81D4FA).withOpacity(0.3),
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
        color: const Color.fromARGB(124, 255, 255, 255),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 241, 243, 243).withOpacity(0.3),
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
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement show detail functionality
                },
                child: const Text("Show Detail",
                    style: TextStyle(color: Colors.lightBlue)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.hourglass_empty, size: 20, color: Colors.orange),
                  Text(
                    "Waiting",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange),
                  ),
                  Text(
                    "5", // Replace with actual number
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.sync, size: 20, color: Colors.lightBlue),
                  Text(
                    "Processing",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.lightBlue),
                  ),
                  Text(
                    "3", // Replace with actual number
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue),
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
                  Color(0xFFE1F5FE),
                  Color(0xFFB3E5FC),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _getShopInfo();
                      imageCache.clear();
                      imageCache.clearLiveImages();
                    },
                    child: ListView(
                      children: [
                        /* const SizedBox(height: 5),
                        bannerWidget, */
                        const SizedBox(height: 16),
                        statsWidget,
                        const SizedBox(height: 16),
                        functionWidget,
                        const SizedBox(height: 16),
                        orderStatusWidget,
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
            backgroundColor: Color(0xFF4FC3F7),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Color(0xFF29B6F6),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Color(0xFF03A9F4),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color(0xFF039BE5),
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: Colors.white,
        onTap: _onBottomItemTapped,
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
            backgroundColor: const Color(0xFF4FC3F7),
            mini: true,
            onPressed: () {
              //Scaffold.of(context).openDrawer();
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(Offset.zero, ancestor: overlay),
                  button.localToGlobal(button.size.bottomRight(Offset.zero),
                      ancestor: overlay),
                ),
                Offset.zero & overlay.size,
              );
              showMenu(
                context: context,
                position: position.shift(Offset(0, -button.size.height - 150)),
                items: <PopupMenuEntry>[
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.add_shopping_cart),
                      title: const Text('Tạo đơn hàng'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const AddOrdersScreen());
                        // Add logic to create order
                      },
                    ),
                  ),
                  //tạo invoice
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.add_shopping_cart),
                      title: const Text('Tạo invoice'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => CreateInvoiceScreen(order: Order(poId: 0, shopId: 0, prodId: 0, cusId: 0, poNo: '', poQty: 0, prodPrice: 0, remark: '', insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', prodCode: '', custCd: '', cusName: '', prodName: '')));
                        // Add logic to create order
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Thêm khách hàng'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const AddCustomersScreen());
                        // Add logic to add customer
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.business),
                      title: const Text('Thêm nhà cung cấp'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const AddSuppliersScreen());
                        // Add logic to add supplier
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.inventory),
                      title: const Text('Thêm sản phẩm'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const AddProductsScreen());
                        // Add logic to add product
                      },
                    ),
                  ),
                ],
              );
            },
            child: const Icon(Icons.add, color: Colors.white, size: 30));
      }),
    );
  }
}
