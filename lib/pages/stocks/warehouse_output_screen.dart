import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/stocks/warehouse_outputHistory_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseOutputScreen extends StatefulWidget {
  const WarehouseOutputScreen({ Key? key }) : super(key: key);

  @override
  _WarehouseOutputScreenState createState() => _WarehouseOutputScreenState();
}

class _WarehouseOutputScreenState extends State<WarehouseOutputScreen> {
  final GlobalController c = Get.put(GlobalController());
  List<Product> products = [];
  List<Customer> customers = [];
  TextEditingController productController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController customerCodeController = TextEditingController(); 

  Future<bool> _outputWareHouse(String prodId, int quantity, String cusId, String prodCode, String custCd) async {
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('outputWarehouse', {
      'SHOP_ID': shopID,
      'PROD_ID': prodId,
      'PROD_QTY': quantity.toString(),
      'CUS_ID': cusId,
      'PROD_CODE': prodCode,
      'CUST_CD': custCd,
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      } else {
        check = false;
      }
    });
    return check;
  }


  Future<List<Product>> _getProducts() async {
    List<dynamic> productList = [];
    await API_Request.api_query('getProductList', {'SHOP_ID': c.shopID.value})
        .then((value) {
      productList = value['data'] ?? [];
    });
    return productList.map((dynamic item) {
      return Product.fromJson(item);
    }).toList();
  } 
  Future<List<Customer>> _getCustomers() async {
    List<dynamic> customerList = [];
    await API_Request.api_query('getCustomerList', {'SHOP_ID': c.shopID.value})
        .then((value) {
      customerList = value['data'] ?? [];
    });
    return customerList.map((dynamic item) {
      return Customer.fromJson(item);
    }).toList();
  }
  @override
  void initState() {
    super.initState();
    _getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
    _getCustomers().then((value) {
      setState(() {
        customers = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: ListView(
          children: [
            DropdownButtonFormField<Product>(
              decoration: InputDecoration(labelText: 'Product'),
              items: products.map((Product product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.prodName ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  productController.text = value?.prodId.toString() ?? '';
                  productCodeController.text = value?.prodCode ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: productController,
              decoration: InputDecoration(labelText: 'Product ID'),
              enabled: false,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: productCodeController,
              decoration: InputDecoration(labelText: 'Product Code'),
              enabled: false,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<Customer>(
              decoration: InputDecoration(labelText: 'Customer'),
              items: customers.map((Customer customer) {
                return DropdownMenuItem<Customer>(
                  value: customer,
                  child: Text(customer.cusName ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  customerController.text = value?.cusId.toString() ?? '';
                  customerCodeController.text = value?.custCd ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: customerController,
              decoration: InputDecoration(labelText: 'Customer ID'),
              enabled: false,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: customerCodeController,
              decoration: InputDecoration(labelText: 'Customer Code'),
              enabled: false,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () async {
                // Implement submit logic here
                bool check = await   _outputWareHouse(productController.text, int.parse(quantityController.text), customerController.text, productCodeController.text, customerCodeController.text);
                if (check) {
                  AwesomeDialog(context: context, dialogType: DialogType.success, title: 'Success', body: Text('Output successful'), btnOkOnPress: () {}).show();
                } else {
                  AwesomeDialog(context: context, dialogType: DialogType.error, title: 'Error', body: Text('Output failed'), btnOkOnPress: () {}).show();
                }
              },
            ),
            ElevatedButton(
              child: Text('Output History'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WarehouseOutputHistoryScreen()));
              },
            ),  
          ],
        ),
      ),
    );
  }
}