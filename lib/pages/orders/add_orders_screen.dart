import 'package:debt_manager/controller/GetXController.dart';
import 'package:flutter/material.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:get/get.dart';

class AddOrdersScreen extends StatefulWidget {
  const AddOrdersScreen({ Key? key }) : super(key: key);

  @override
  _AddOrdersScreenState createState() => _AddOrdersScreenState();
}

class _AddOrdersScreenState extends State<AddOrdersScreen> {
  final TextEditingController productController = TextEditingController();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();  
  final TextEditingController noteController = TextEditingController();
  String productCode = '';
  String customerCode = ''; 

  final GlobalController c = Get.put(GlobalController());

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

  List<Customer> customers = [];
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

  void _getCustomerList() async {
    await _getCustomers().then((value) {
      setState(() {
        customers = value;
      });
    });
  }

  void _getProductList() async {
    await _getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
  }  

  Future<bool> _addOrder(String orderNumber, String prodId, String cusId, String productCode, String customerCode, int quantity, double price, String note) async {
    // Add product logic here
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('addNewOrder', {'PO_NO': orderNumber,'PROD_ID': prodId , 'PROD_CODE': productCode, 'CUS_ID': cusId, 'CUST_CD': customerCode, 'PO_QTY': quantity.toString(), 'PROD_PRICE': price.toString(), 'REMARK': note, 'SHOP_ID': shopID})
        .then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;        
      } else {
        check = false;
      }
    });
    return check;    
  }




 //generate order number with format: SO-YYYYMMDD-NNNN  
 String _generateOrderNumber() {
  String date = DateTime.now().toString().substring(0, 10);
  String number = (DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0');
  return 'SO-$date-$number';
 }  

  @override
  void initState() {    
    _getProductList();
    _getCustomerList();
    orderNumberController.text = _generateOrderNumber();
    super.initState();
  }

  @override
  void dispose() {
    productController.dispose();  
    customerController.dispose();
    orderNumberController.dispose();
    quantityController.dispose();
    priceController.dispose();
    noteController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
                DropdownButtonFormField<Product>(
                onChanged: (Product? value) {
                  setState(() {
                    productController.text = value?.prodId.toString() ?? '';
                    productCode = value?.prodCode ?? '';  
                  });
                },
                items: products.map((Product product) {
                  return DropdownMenuItem<Product>(
                    value: product,
                    child: Text(product.prodName ?? ''),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Mã sản phẩm',
                  hintText: 'Nhập mã sản phẩm',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Customer>(
                onChanged: (Customer? value) {
                  setState(() {
                    customerController.text = value?.cusId.toString() ?? '';
                    customerCode = value?.custCd ?? '';
                  });
                },
                items: customers.map((Customer customer) {
                  return DropdownMenuItem<Customer>(
                    value: customer,
                    child: Text(customer.cusName ?? ''),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Khách hàng',
                  hintText: 'Chọn khách hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: orderNumberController,
                decoration: const InputDecoration(
                  labelText: 'Số đơn hàng',
                  hintText: 'Nhập số đơn hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Số lượng',
                  hintText: 'Nhập số lượng',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Giá sản phẩm',
                  hintText: 'Nhập giá sản phẩm',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  hintText: 'Nhập ghi chú',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                 _addOrder(orderNumberController.text,productController.text, customerController.text, productCode, customerCode, int.parse(quantityController.text), double.parse(priceController.text), noteController.text).then((value) {
                    if (value) {      
                      Get.back();
                    } else {
                      Get.snackbar('Thông báo', 'Thêm đơn hàng thất bại');
                    }
                  });
                },
                child: const Text('Lưu đơn hàng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}