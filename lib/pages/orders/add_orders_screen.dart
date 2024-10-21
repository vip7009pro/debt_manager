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

  List<Order> selectedOrders = [];

  Future<bool> _addOrder(Order order) async {
    bool check = true;
    await API_Request.api_query('addNewOrder', order.toJson())
        .then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;        
      } else {
        check = false;
      }
    });
    return check;    
  }

  Future<void> _addAllOrders() async {
    if (selectedOrders.isEmpty) {
      Get.snackbar('Thông báo', 'Vui lòng chọn ít nhất một sản phẩm');
      return;
    }

    bool allSuccess = true;
    for (var order in selectedOrders) {
      order.cusId = int.parse(customerController.text);
      order.custCd = customerCode;
      order.remark = noteController.text;
      bool success = await _addOrder(order);
      if (!success) {
        allSuccess = false;
        Get.snackbar('Thông báo', 'Thêm sản phẩm ${order.prodName} thất bại');
      }
    }

    if (allSuccess) {
      Get.back();
      Get.snackbar('Thông báo', 'Thêm tất cả đơn hàng thành công');
    } else {
      Get.snackbar('Thông báo', 'Một số đơn hàng thêm thất bại');
    }
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
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[100]!, Colors.purple[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                DropdownButtonFormField<Product>(
                  onChanged: (Product? value) {
                    if (value != null) {
                      setState(() {
                        productController.text = value.prodId.toString();
                        productCode = value.prodCode ?? '';
                        
                        /* selectedOrders.add(Order(
                          poId: 0, // This will be assigned by the backend
                          shopId: int.parse(c.shopID.value),
                          prodId: value.prodId,
                          cusId: 0, // This will be set when a customer is selected
                          poNo: orderNumberController.text,
                          poQty: 1,
                          prodPrice: value.prodPrice,
                          remark: '',
                          insDate: DateTime.now(),
                          insUid: '',
                          updDate: DateTime.now(),
                          updUid: '',
                          prodCode: value.prodCode,
                          custCd: customerCode,
                          cusName: '',
                          prodName: value.prodName,
                        )); */
                      });
                    }
                  },
                  items: products.map((Product product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Text(product.prodName ?? ''),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Mã sản phẩm',
                    hintText: 'Nhập mã sản phẩm',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
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
                  decoration: InputDecoration(
                    labelText: 'Khách hàng',
                    hintText: 'Chọn khách hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: orderNumberController,
                  decoration: InputDecoration(
                    labelText: 'Số đơn hàng',
                    hintText: 'Nhập số đơn hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Số lượng',
                    hintText: 'Nhập số lượng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Giá sản phẩm',
                    hintText: 'Nhập giá sản phẩm',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    hintText: 'Nhập ghi chú',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                //add a button to add product to list 
                ElevatedButton(
                  onPressed: () {
                    selectedOrders.add(Order(poId: 0, shopId: int.parse(c.shopID.value), prodId: int.parse(productController.text), cusId: int.parse(customerController.text), poNo: orderNumberController.text, poQty: int.parse(quantityController.text), prodPrice: double.parse(priceController.text), remark: noteController.text, insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', prodCode: productCode, custCd: customerCode, cusName: '', prodName: products.firstWhere((p) => p.prodId == int.parse(productController.text)).prodName));
                  },
                  child: Text('Thêm đơn hàng'),
                ),    

                ElevatedButton(
                  onPressed: _addAllOrders,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Lưu đơn hàng', style: TextStyle(fontSize: 18)),
                ),

                // Updated selected orders card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selected Products:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ...selectedOrders.map((order) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(child: Text(order.prodName)),
                              TextFormField(
                                initialValue: order.poQty.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    order.poQty = int.tryParse(value) ?? 1;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Qty',
                                  constraints: BoxConstraints(maxWidth: 60),
                                ),
                              ),
                              SizedBox(width: 8),
                              TextFormField(
                                initialValue: order.prodPrice.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    order.prodPrice = double.tryParse(value) ?? 0;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Price',
                                  constraints: BoxConstraints(maxWidth: 80),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.red),
                                onPressed: () => selectedOrders.remove(order),
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
