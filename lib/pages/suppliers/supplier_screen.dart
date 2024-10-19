import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/suppliers/add_suppliers_screen.dart';
import 'package:debt_manager/pages/suppliers/update_supplier_screen.dart';
import 'package:flutter/material.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:get/get.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({ Key? key }) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final GlobalController c = Get.put(GlobalController()); 
  List<Vendor> suppliers = [];
  List<Vendor> filteredSuppliers = [];
  TextEditingController searchController = TextEditingController();

  Future<List<Vendor>> _getSuppliers() async {
    List<dynamic> vendorList = [];
    await API_Request.api_query('getvendorlist', {'SHOP_ID': c.shopID.value}).then((value) {
      vendorList = value['data'] ?? [];
    });
    return vendorList.map((dynamic item) {
      return Vendor.fromJson(item);
    }).toList();
  }

  void filterSuppliers(String query) {
    setState(() {
      filteredSuppliers = suppliers.where((supplier) =>
        supplier.vendorName.toLowerCase().contains(query.toLowerCase()) ||
        supplier.vendorCode.toLowerCase().contains(query.toLowerCase()) ||
        supplier.vendorPhone.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getSuppliers().then((value) {
      setState(() {
        suppliers = value;
        filteredSuppliers = suppliers;
      });
    });
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
        title: Text('Supplier', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 224, 56, 98),
        actions: [
          IconButton(
            onPressed: () async {              
              final result = await Get.to(() => AddSuppliersScreen());
              if (true) {
                List<Vendor> refreshedSuppliers = await _getSuppliers();
                setState(() {
                  suppliers = refreshedSuppliers;
                  filterSuppliers(searchController.text);
                });
              }
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Suppliers',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: filterSuppliers,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  List<Vendor> refreshedSuppliers = await _getSuppliers();
                  setState(() {
                    suppliers = refreshedSuppliers;
                    filteredSuppliers = suppliers;
                    searchController.clear();
                  });
                },
                child: ListView.builder(
                  itemCount: filteredSuppliers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: Colors.white.withOpacity(0.9),
                      child: ListTile(
                        leading: Icon(Icons.business, color: Colors.orange),
                        title: Text(
                          filteredSuppliers[index].vendorName,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        subtitle: Text(
                          filteredSuppliers[index].vendorPhone,
                          style: TextStyle(color: Colors.green),
                        ),
                        trailing: Text(
                          'ID: ${filteredSuppliers[index].vendorCode}',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          final result = await Get.to(() => UpdateSupplierScreen(supplier: filteredSuppliers[index]));
                          if (result == true) {
                            List<Vendor> refreshedSuppliers = await _getSuppliers();
                            setState(() {
                              suppliers = refreshedSuppliers;
                              filterSuppliers(searchController.text);
                            });
                          }
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
