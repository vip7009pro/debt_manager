import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/pages/customers/add_customers_screen.dart';  

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({ Key? key }) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  final GlobalController c = Get.put(GlobalController());

  List<Customer> customers = [];
  
  Future<List<Customer>> _getCustomers() async {
    List<dynamic> customerList = [];
    await API_Request.api_query('getCustomerList', {'SHOP_ID': c.shopID.value}).then((value) {
      customerList = value['data'] ?? [];
    });
    return customerList.map((dynamic item) {
      return Customer.fromJson(item);
    }).toList();
  }
  void _getCustomerList() async {
    await _getCustomers().then((value) {
      setState(() {
        customers = value;
      });
    });
  }

  @override
  void initState() {
    _getCustomerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 82, 176),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddCustomersScreen());
            },
            icon: Icon(Icons.add),
            color: Colors.yellow,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
           _getCustomerList();
        },
        color: Colors.orange,
        backgroundColor: Colors.lightBlue,
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              title: Text(
                customers[index].cusName ?? '',
                style: TextStyle(color: Colors.indigo),
              ),
              subtitle: Text(
                customers[index].cusPhone ?? '',
                style: TextStyle(color: Colors.teal),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.red),
              onTap: () {
                // Add logic to view customer details
              },
            );
          },
        ),
      ),      
    );
  }
}