import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/pages/orders/add_orders_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({ Key? key }) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
      body: ListView.builder(
        itemCount: 10, // Replace with actual number of POs
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('PO${index + 1}'),
              ),
              title: Text('Purchase Order #${index + 1}'),
              subtitle: Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
              trailing: Text('\$${(index + 1) * 100}'),
              onTap: () {
                // Navigate to PO details
              },
            ),
          );
        },
      ),
    );
  }
}