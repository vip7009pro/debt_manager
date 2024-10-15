import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/suppliers/add_suppliers_screen.dart';
import 'package:flutter/material.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:get/get.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({ Key? key }) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  List<Vendor> suppliers = [];
  final GlobalController c = Get.put(GlobalController()); 

  Future<List<Vendor>> _getSuppliers() async {
    List<dynamic> vendorList = [];
    await API_Request.api_query('getvendorlist', {'SHOP_ID': c.shopID.value}).then((value) {
      vendorList = value['data'] ?? [];
    });
    return vendorList.map((dynamic item) {
      return Vendor.fromJson(item);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _getSuppliers().then((value) {
      setState(() {
        suppliers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 224, 56, 98),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddSuppliersScreen());
            },
            icon: Icon(Icons.add, color: Colors.yellow)
          )
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
            List<Vendor> refreshedSuppliers = await _getSuppliers();
            setState(() {
              suppliers = refreshedSuppliers;
            });
          },
          child: ListView.builder(
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.white.withOpacity(0.9),
                child: ListTile(
                  leading: Icon(Icons.business, color: Colors.orange),
                  title: Text(
                    suppliers[index].vendorName,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  subtitle: Text(
                    suppliers[index].vendorPhone,
                    style: TextStyle(color: Colors.green),
                  ),
                  trailing: Text(
                    'ID: ${suppliers[index].vendorCode}',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Add logic to view supplier details
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