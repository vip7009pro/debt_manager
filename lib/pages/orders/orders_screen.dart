import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
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
  List<Order> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

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
        filteredOrders = orders;
      });
    });
  }

  void _filterOrders(String query) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
              GlobalFunction.convertVietnameseString(order.prodName).toLowerCase().contains(GlobalFunction.convertVietnameseString(query).toLowerCase()))
          .toList();
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
        backgroundColor: const Color.fromARGB(255, 115, 231, 163),
        actions: [
          IconButton(onPressed: () {
            Get.to(() => AddOrdersScreen());
          }, icon: Icon(Icons.add, color: Colors.yellow, size: 22))
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                   _getOrderList();
                },
                child: ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    Color cardColor = index % 5 == 0 ? Colors.red[100]! :
                                      index % 5 == 1 ? Colors.green[100]! :
                                      index % 5 == 2 ? Colors.blue[100]! :
                                      index % 5 == 3 ? Colors.orange[100]! :
                                      Colors.purple[100]!;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      color: cardColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Text(
                            filteredOrders[index].poNo.substring(filteredOrders[index].poNo.length - 4),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        title: Text(
                          '#${filteredOrders[index].poNo} \n SP: ${filteredOrders[index].prodName} \n KH: ${filteredOrders[index].cusName} \n QTY: ${filteredOrders[index].poQty} \n Price: ${filteredOrders[index].prodPrice}',
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Text(
                          '${filteredOrders[index].insDate.toString().split(' ')[0]} Note:${filteredOrders[index].remark}',
                          style: TextStyle(color: Colors.black54, fontSize: 11),
                        ),
                        trailing: Text(
                          '\$${(filteredOrders[index].poQty * filteredOrders[index].prodPrice).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        onTap: () {
                          Get.to(() => CreateInvoiceScreen(order: filteredOrders[index]));
                        },
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