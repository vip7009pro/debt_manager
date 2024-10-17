import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/stocks/warehouse_outputHistory_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WarehouseOutputScreen extends StatefulWidget {
  final Product product;
  final String wh_in_id;
  const WarehouseOutputScreen({Key? key, required this.product, required this.wh_in_id}) : super(key: key);  

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
  Product selectedProduct = Product(prodId: 0, prodCode: '', prodName: '', prodImg: '', shopId: 0, prodDescr: '', prodPrice: 0, insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', catId: 0);
  String wh_in_id = ''; 
  Future<bool> _outputWareHouse(String prodId, int quantity, String cusId,
      String prodCode, String custCd, String wHInId) async {
    print('wh_in_id' + wHInId);
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('outputWarehouse', {
      'SHOP_ID': shopID,
      'PROD_ID': prodId,
      'PROD_QTY': quantity.toString(),
      'CUS_ID': cusId,
      'PROD_CODE': prodCode,
      'CUST_CD': custCd,
      'WH_IN_ID': wHInId, 
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
    Product tempSelectedProduct = widget.product;
    productController.text = tempSelectedProduct.prodId.toString();
    productCodeController.text = tempSelectedProduct.prodCode;  
    wh_in_id = widget.wh_in_id; 
    _getProducts().then((value) {
      setState(() {
        products = value;
        // set selectedProduct to be the product that has the same prodId as the tempSelectedProduct
        selectedProduct = products.firstWhere((element) => element.prodId == tempSelectedProduct.prodId); 
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouse Output'),
        backgroundColor: Color(0xFF3F51B5),
      ),
      body: Container(
        color: Color(0xFFF5F5F5),
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              DropdownButtonFormField<Product>(
                value: selectedProduct,
                decoration: InputDecoration(
                  labelText: 'Product',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF3F51B5)),
                  ),
                ),
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
                decoration: InputDecoration(
                  labelText: 'Product ID',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF3F51B5)),
                  ),
                ),
                enabled: false,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: productCodeController,
                decoration: InputDecoration(
                  labelText: 'Product Code',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF3F51B5)),
                  ),
                ),
                enabled: false,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF3F51B5)),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Customer>(
                decoration: InputDecoration(
                  labelText: 'Customer',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF3F51B5)),
                  ),
                ),
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
                decoration: InputDecoration(
                  labelText: 'Customer ID',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF3F51B5)),
                  ),
                ),
                enabled: false,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: customerCodeController,
                decoration: InputDecoration(
                  labelText: 'Customer Code',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF3F51B5)),
                  ),
                ),
                enabled: false,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F51B5),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        
                        bool check = await _outputWareHouse(
                            productController.text,
                            int.parse(quantityController.text),
                            customerController.text,
                            productCodeController.text,
                            customerCodeController.text,
                            wh_in_id);
                        if (check) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            title: 'Success',
                            desc: 'Output successful',
                            btnOkColor: Color(0xFF4CAF50),
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: 'Error',
                            desc: 'Output failed',
                            btnOkColor: Color(0xFFF44336),
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Output History'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF607D8B),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WarehouseOutputHistoryScreen()));
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
