import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/invoices/create_invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/pages/orders/add_orders_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({ Key? key }) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = []; 

  final GlobalController c = Get.put(GlobalController());
  
  Future<List<Order>> _getOrders() async {
    List<dynamic> orderList = [];
    await API_Request.api_query('getOrderList', {'SHOP_ID': c.shopID.value}).then((value) {
      orderList = value['data'] ?? [];
    });
    return orderList.map((dynamic item) {
      return Order.fromJson(item);
    }).toList();
  }
  void _getOrderList() async {
    await _getOrders().then((value) {
      setState(() {
        orders = value;
      });
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
        title: Text('Orders'),
        backgroundColor: const Color.fromARGB(255, 115, 231, 163),
        actions: [
          IconButton(onPressed: () {
            Get.to(() => AddOrdersScreen());
          }, icon: Icon(Icons.add, color: Colors.yellow))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[100]!, Colors.purple[100]!],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
             _getOrderList();
          },
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Color cardColor = index % 5 == 0 ? Colors.red[100]! :
                                index % 5 == 1 ? Colors.green[100]! :
                                index % 5 == 2 ? Colors.blue[100]! :
                                index % 5 == 3 ? Colors.orange[100]! :
                                Colors.purple[100]!;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: cardColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Text(
                      orders[index].poNo.substring(orders[index].poNo.length - 4),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    '#${orders[index].poNo} \n SP: ${orders[index].prodName} \n KH: ${orders[index].cusName} \n QTY: ${orders[index].poQty} \n Price: ${orders[index].prodPrice}',
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${orders[index].insDate.toString().split(' ')[0]} Note:${orders[index].remark}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: Text(
                    '\$${(orders[index].poQty * orders[index].prodPrice).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onTap: () {
                    Get.to(() => CreateInvoiceScreen(order: orders[index]));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}