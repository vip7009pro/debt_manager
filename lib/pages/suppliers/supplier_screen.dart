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
        title: Text('Supplier'),
        actions: [
          IconButton(onPressed: () {
            Get.to(() => AddSuppliersScreen());
          }, icon: Icon(Icons.add))
        ],  
      ),
      
      body: RefreshIndicator(
        onRefresh: () async {
          List<Vendor> refreshedSuppliers = await _getSuppliers();
          setState(() {
            suppliers = refreshedSuppliers;
          });
        },
        child: ListView.builder(
          itemCount: suppliers.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.business),
              title: Text(suppliers[index].vendorName),
              subtitle: Text(suppliers[index].vendorPhone),
              trailing: Text('ID: ${suppliers[index].vendorCode}'),
              onTap: () {
                // Add logic to view supplier details
              },
            );
          },
        ),
      ),
    );
  }
}