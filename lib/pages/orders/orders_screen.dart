import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/invoices/create_invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/pages/orders/add_orders_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [], originalOrders = [];
  List<Order> filteredOrders = [];
  TextEditingController searchController = TextEditingController();
  bool showOnlyBalance = false;

  final GlobalController c = Get.put(GlobalController());

  Future<List<Order>> _getOrders() async {
    List<dynamic> orderList = [];
    await API_Request.api_query('getOrderList', {'SHOP_ID': c.shopID.value, 'JUST_PO_BALANCE': showOnlyBalance})
        .then((value) {
      orderList = value['data'] ?? [];
    });
    originalOrders = orderList.map((dynamic item) {
      return Order.fromJson(item);
    }).toList();
    return originalOrders;
  }

  void _getOrderList() async {
    await _getOrders().then((value) {
      setState(() {
        orders = value;
        filteredOrders = orders;
      });
    });
  }

  void _filterOrders(String query) {    
    setState(() {
      print(showOnlyBalance.toString());
      filteredOrders = orders.where((order) {
        bool matchesSearch = GlobalFunction.convertVietnameseString(
                order.prodName)
            .toLowerCase()
            .contains(
                GlobalFunction.convertVietnameseString(query).toLowerCase());
        return matchesSearch; 
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders', style: TextStyle(fontSize: 18)),
        backgroundColor: Color(0xFF2196F3),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await Get.to(() => AddOrdersScreen());
                if (true) {
                  _getOrderList();
                }
              },
              icon: Icon(Icons.add, color: Colors.white, size: 22))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[50]!,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search products',
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: _filterOrders,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: showOnlyBalance,
                        onChanged: (value) {                          
                          setState(() { 
                            showOnlyBalance = value ?? false;                           
                          });
                        },
                      ),
                      Text('Just Balance', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _getOrderList();
                },
                child: ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    Color cardColor =
                        index.isEven ? Colors.white : Colors.grey[50]!;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      color: cardColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 150),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          leading: Container(
                            width: 50,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  filteredOrders[index].poNo.substring(
                                      filteredOrders[index].poNo.length - 4),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                      'http://14.160.33.94:3010/product_images/${c.shopID.value}_${filteredOrders[index].prodCode}_${0}.jpg'),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            '#${filteredOrders[index].poNo} \n SP: ${filteredOrders[index].prodName} \n KH: ${filteredOrders[index].cusName} \n QTY: ${filteredOrders[index].poQty} \n DEL_QTY: ${filteredOrders[index].deliveredQty} \n BAL_QTY: ${filteredOrders[index].balanceQty} \n Price: ${filteredOrders[index].prodPrice}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          subtitle: Text(
                            '${filteredOrders[index].insDate.toString().split(' ')[0]} Note:${filteredOrders[index].remark}',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 10),
                          ),
                          trailing: Text(
                            '\$${(filteredOrders[index].poQty * filteredOrders[index].prodPrice).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          onTap: () async {
                            final result = await Get.to(() =>
                                CreateInvoiceScreen(
                                    order: filteredOrders[index]));
                            if (true) {
                              _getOrderList();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
