import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/pages/customers/add_customers_screen.dart';
import 'package:debt_manager/pages/customers/update_customer_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({ Key? key }) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final GlobalController c = Get.put(GlobalController());
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  TextEditingController searchController = TextEditingController();
  
  Future<List<Customer>> _getCustomers() async {
    List<dynamic> customerList = [];
    int shopID = c.shopID.value;
    await API_Request.api_query('getCustomerList', {'SHOP_ID': shopID}).then((value) {
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
        filteredCustomers = customers;
      });
    });
  }

  void filterCustomers(String query) {
    setState(() {
      filteredCustomers = customers.where((customer) =>
        customer.cusName.toLowerCase().contains(query.toLowerCase()) ||
        customer.cusPhone.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  void initState() {
    _getCustomerList();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers', style: TextStyle(color: Colors.white)),
        //change back arrow color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),  
        backgroundColor: const Color.fromARGB(255, 39, 82, 176),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Get.to(() => AddCustomersScreen());
              if (true) {
                List<Customer> refreshedCustomers = await _getCustomers();
                setState(() {
                  customers = refreshedCustomers;
                  filterCustomers(searchController.text);
                });
              }
            },
            icon: Icon(Icons.add),
            color: Colors.yellow,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Customers',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: filterCustomers,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _getCustomerList();
                searchController.clear();
              },
              color: Colors.orange,
              backgroundColor: Colors.lightBlue,
              child: ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    title: Text(
                      filteredCustomers[index].cusName ?? '',
                      style: TextStyle(color: Colors.indigo),
                    ),
                    subtitle: Text(
                      filteredCustomers[index].cusPhone ?? '',
                      style: TextStyle(color: Colors.teal),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.red),
                    onTap: () async {
                      final result = await Get.to(() => UpdateCustomerScreen(customer: filteredCustomers[index]));
                      if (result == true) {
                        List<Customer> refreshedCustomers = await _getCustomers();
                        setState(() {
                          customers = refreshedCustomers;
                          filterCustomers(searchController.text);
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
