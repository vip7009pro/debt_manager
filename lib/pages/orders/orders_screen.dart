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
        actions: [
          IconButton(onPressed: () {
            Get.to(() => AddOrdersScreen());
          }, icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
           _getOrderList();
        },
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 158, 225, 245), 
                  radius: 25,
                  child: Text(orders[index].poNo.substring(orders[index].poNo.length - 4)),
                ),
                title: Text('#${orders[index].poNo} \n SP: ${orders[index].prodName} \n KH: ${orders[index].cusName} \n QTY: ${orders[index].poQty} \n Price: ${orders[index].prodPrice}'),
                subtitle: Text('${orders[index].insDate.toString().split(' ')[0]} Note:${orders[index].remark}'),
                trailing: Text('\$${(orders[index].poQty * orders[index].prodPrice).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                onTap: () {
                  Get.to(() => CreateInvoiceScreen(order: orders[index]));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}