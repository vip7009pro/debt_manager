import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/stocks/warehouse_inputHistory_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WarehouseInputScreen extends StatefulWidget {
  const WarehouseInputScreen({Key? key}) : super(key: key);
  @override
  _WarehouseInputScreenState createState() => _WarehouseInputScreenState();
}
class _WarehouseInputScreenState extends State<WarehouseInputScreen> {
  final GlobalController c = Get.put(GlobalController());
  final TextEditingController productController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController bepController = TextEditingController();
  Future<bool> _inputWareHouse(String prodId, int quantity, String prodStatus,
      String prodCode, String vendorCode, double Bep) async {
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('inputWarehouse', {
      'SHOP_ID': shopID,
      'PROD_ID': prodId,
      'PROD_QTY': quantity.toString(),
      'PROD_STATUS': prodStatus,
      'PROD_CODE': prodCode,
      'VENDOR_CODE': vendorCode,
      'BEP': Bep.toString(),
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      } else {
        check = false;
      }
    });
    return check;
  }
  List<Product> products = [];
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
  List<Vendor> suppliers = [];
  Future<List<Vendor>> _getSuppliers() async {
    List<dynamic> vendorList = [];
    await API_Request.api_query('getvendorlist', {'SHOP_ID': c.shopID.value})
        .then((value) {
      vendorList = value['data'] ?? [];
    });
    return vendorList.map((dynamic item) {
      return Vendor.fromJson(item);
    }).toList();
  }
  @override
  void initState() {
    bepController.text = '0';
    quantityController.text = '0';
    super.initState();
    _getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
    _getSuppliers().then((value) {
      setState(() {
        suppliers = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              DropdownButtonFormField<Product>(
                onChanged: (Product? value) {
                  setState(() {
                    productController.text = value?.prodId.toString() ?? '';
                    productCodeController.text = value?.prodCode ?? '';
                  });
                },
                items: products.map((Product product) {
                  return DropdownMenuItem<Product>(
                    value: product,
                    child: Text(product.prodName ?? ''),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Product',
                  hintText: 'Select a product',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: productController,
                decoration: InputDecoration(
                  labelText: 'Product ID',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: productCodeController,
                decoration: InputDecoration(
                  labelText: 'Product Code',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'Y', child: Text('Available')),
                  DropdownMenuItem(value: 'P', child: Text('Reserved')),
                  DropdownMenuItem(value: 'N', child: Text('Damaged')),
                ],
                onChanged: (value) {
                  setState(() {
                    statusController.text = value ?? '';
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Vendor>(
                decoration: InputDecoration(
                  labelText: 'Vendor',
                  border: OutlineInputBorder(),
                ),
                items: suppliers.map((Vendor supplier) {
                  return DropdownMenuItem<Vendor>(
                    value: supplier,
                    child: Text(supplier.vendorName ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    vendorController.text = value?.vendorCode ?? '';
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: bepController,
                decoration: InputDecoration(
                  labelText: 'BEP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey[800],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        bool check = await _inputWareHouse(
                            productController.text,
                            int.parse(quantityController.text),
                            statusController.text,
                            productCodeController.text,
                            vendorController.text,
                            double.parse(bepController.text));
                        if (check) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.bottomSlide,
                            title: 'Success',
                            desc: 'Input warehouse successfully',
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            title: 'Error',
                            desc: 'Input warehouse failed',
                            btnCancelOnPress: () {},
                          ).show();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      child: Text('Input History'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueGrey[800],
                        side: BorderSide(color: Colors.blueGrey[800]!),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WarehouseInputHistoryScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
