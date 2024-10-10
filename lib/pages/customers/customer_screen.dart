import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/pages/customers/add_customers_screen.dart';  

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({ Key? key }) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(onPressed: () {
            Get.to(() => AddCustomersScreen());
          }, icon: Icon(Icons.add))
        ],
      ),
      
    );
  }
}