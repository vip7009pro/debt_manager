import 'dart:convert';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/features/user_auth/presentation/pages/login_page.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/categories/category_screen.dart';
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
import 'package:debt_manager/pages/stocks/warehouse_tab_screen.dart';
import 'package:debt_manager/pages/suppliers/supplier_screen.dart';
import 'package:debt_manager/pages/suppliers/add_suppliers_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedBottomIndex = 0;
  int _po_qty = 0;  
  double _po_amount = 0;
  double _revenue = 0;
  double _profit = 0;

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
  int mobileVer = 5;
  late Timer _timer;

  Future<void> _getPOData() async {
    await API_Request.api_query('getTodayPOQtyAndAmount', {
      'SHOP_ID': c.shopID.value == 0
          ? await LocalDataAccess.getVariable('shopId')
          : c.shopID.value
    }).then((value) {
       if (value['tk_status'] == 'OK') {
        setState(() {
          _po_qty = value['data'][0]['PO_QTY'];
          _po_amount = double.parse(value['data'][0]['PO_AMOUNT'].toString());        
        });
      }
    });
  }

  Future<void> _getInvoiceData() async {
    await API_Request.api_query('getTodayInvoiceQtyAndAmount', {
      'SHOP_ID': c.shopID.value == 0
          ? await LocalDataAccess.getVariable('shopId')
          : c.shopID.value
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        setState(() {
          _revenue = double.parse(value['data'][0]['INVOICE_AMOUNT'].toString());            
        });
      }
    });
  }


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
      'SHOP_ID': c.shopID.value == 0
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
    c.shopID.value = int.parse(shopId);
    print('c.shopID.value' + shopId);
  }

  @override
  void initState() {
    _loadshopidfromlocaldatabse();
    _getShopInfo();
    _getInvoiceData();
    _getPOData(); 
    //c.loadContacts(); // Add this line to load contacts
    super.initState();
  }

  Widget _buildFunctionWidget(IconData icon, String text, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
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
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsWidget(IconData icon, String title, String amount, Color color) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: color,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 1).format(double.parse(amount)),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white),
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
      backgroundColor: const Color.fromARGB(255, 114, 184, 151),
    );

    final bannerWidget = SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 100,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.orange,
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
                        fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    final drawer = Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 226, 234, 241), const Color.fromARGB(255, 212, 141, 224)],
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.deepPurple,
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
                  style: TextStyle(color: Colors.indigo, fontSize: 14)),
              leading: const Icon(
                Icons.shopping_bag,
                color: Colors.orange,
                size: 20,
              ),
              childrenPadding: const EdgeInsets.only(left: 10),
              children: [
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const FaIcon(
                    FontAwesomeIcons.list,
                    color: Colors.teal,
                    size: 18,
                  ),
                  title: const Text("Danh sách cửa hàng",
                      style: TextStyle(color: Colors.indigo, fontSize: 13)),
                  onTap: () {
                    Get.to(() => const ShopListScreen());
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("Quản lý nhân viên",
                  style: TextStyle(color: Colors.indigo, fontSize: 14)),
              leading: const Icon(
                Icons.people,
                color: Colors.green,
                size: 20,
              ),
              childrenPadding: const EdgeInsets.only(left: 10),
              children: [
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const FaIcon(
                    FontAwesomeIcons.list,
                    color: Colors.teal,
                    size: 18,
                  ),
                  title: const Text("Danh sách nhân viên",
                      style: TextStyle(color: Colors.indigo, fontSize: 13)),
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
                size: 20,
              ),
              title: const Text("Logout", style: TextStyle(color: Colors.red, fontSize: 14)),
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
      ),
    );
    final functionWidget = Center(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 238, 197, 245).withOpacity(0.1), Colors.blue.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0),
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
                    () => Get.to(() => const OrdersScreen()), Colors.red),
                _buildFunctionWidget(Icons.description, "Invoice",
                    () => Get.to(() => const InvoiceScreen()), Colors.green),
                _buildFunctionWidget(Icons.inventory, "Products",
                    () => Get.to(() => const ProductsScreen()), Colors.blue),
                _buildFunctionWidget(Icons.category, "Categories",
                    () => Get.to(() => const CategoryScreen()), const Color.fromARGB(255, 183, 116, 223)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [                
                _buildFunctionWidget(Icons.warehouse, "Warehouse",
                    () => Get.to(() => const WarehouseTabScreen()), Colors.teal),
                _buildFunctionWidget(Icons.people, "Supplier",
                    () => Get.to(() => const SupplierScreen()), Colors.indigo),
                _buildFunctionWidget(Icons.person, "Customers",
                    () => Get.to(() => const CustomerScreen()), Colors.pink),
                     _buildFunctionWidget(Icons.bar_chart, "Report",
                    () => Get.to(() => const ReportScreen()), Colors.deepOrange),           
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
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 241, 241, 241).withOpacity(0.1), const Color.fromARGB(255, 245, 237, 167).withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatsWidget(Icons.shopping_cart, "PO", _po_amount.toString(), Colors.blue),
          _buildStatsWidget(Icons.attach_money, "Revenue", _revenue.toString(), Colors.green),
          _buildStatsWidget(Icons.trending_up, "Profit", _profit.toString(), Colors.orange),
        ],
      ),
    );
    final orderStatusWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1), const Color.fromARGB(255, 233, 206, 204).withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0),
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
                    color: Colors.deepPurple),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement show detail functionality
                },
                child: const Text("Show Detail",
                    style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.hourglass_empty, size: 20, color: Colors.blue),
                  Text(
                    "Waiting",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                  Text(
                    "5", // Replace with actual number
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.sync, size: 20, color: Colors.green),
                  Text(
                    "Processing",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green),
                  ),
                  Text(
                    "3", // Replace with actual number
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
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
                  Color(0xFFFFF9C4), // Light yellow
                  Color(0xFFE1F5FE), // Light blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _getShopInfo();
                       _getPOData(); 
                       _getInvoiceData();                     
                      imageCache.clear();
                      imageCache.clearLiveImages();
                    },
                    child: ListView(
                      children: [
                        /* const SizedBox(height: 5),
                        bannerWidget, */
                        const SizedBox(height: 16),
                        const Text(
                          'Today\'s Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple, // Added color to match theme
                          ),
                        ),
                        statsWidget,
                        const SizedBox(height: 16),
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple, // Added color to match theme
                          ),
                        ),
                        functionWidget,
                        const SizedBox(height: 16),
                        const Text(
                          'Order Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple, // Added color to match theme
                          ),
                        ),
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
            backgroundColor: Color(0xFFFFF9C4), // Light yellow
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Color(0xFFE1F5FE), // Light blue
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Color(0xFFF0F4C3), // Light lime
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color(0xFFE8EAF6), // Light indigo
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onBottomItemTapped,
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
            backgroundColor: Colors.deepPurple,
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
                      leading: const Icon(Icons.add_shopping_cart, color: Colors.green),
                      title: const Text('Tạo đơn hàng', style: TextStyle(color: Colors.green)),
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
                      leading: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                      title: const Text('Tạo invoice', style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => CreateInvoiceScreen(order: Order(poId: 0, shopId: 0, prodId: 0, cusId: 0, poNo: '', poQty: 0, prodPrice: 0, remark: '', insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', prodCode: '', custCd: '', cusName: '', prodName: '', deliveredQty: 0, balanceQty: 0)));
                        // Add logic to create order
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.person_add, color: Colors.orange),
                      title: const Text('Thêm khách hàng', style: TextStyle(color: Colors.orange)),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const AddCustomersScreen());
                        // Add logic to add customer
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.business, color: Colors.purple),
                      title: const Text('Thêm nhà cung cấp', style: TextStyle(color: Colors.purple)),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const AddSuppliersScreen());
                        // Add logic to add supplier
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.inventory, color: Colors.red),
                      title: const Text('Thêm sản phẩm', style: TextStyle(color: Colors.red)),
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
