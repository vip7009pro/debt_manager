import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';
class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({ Key? key }) : super(key: key);

  @override
  _AddProductsScreenState createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? productCategory;
  String? productName;
  String? productDescription;
  double? productPrice;
  String? productCode;

  final productCategoryController = TextEditingController();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productCodeController = TextEditingController();
  final GlobalController c = Get.put(GlobalController());
  
  //create random product code contains letter and number of length 10
  String createRandomProductCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (_) => chars[Random().nextInt(chars.length)]).join('');
  } 


  @override
  Widget build(BuildContext context) {
    productCodeController.text = createRandomProductCode();


  Future<bool> _addProduct(String productCode, String productCategory, String productName, String productDescription, double productPrice) async {
    // Add product logic here
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('addNewProduct', {'PROD_CODE': productCode, 'CAT_ID': productCategory, 'PROD_NAME': productName, 'PROD_DESCR': productDescription, 'PROD_PRICE': productPrice, 'SHOP_ID': shopID, 'PROD_IMG': 'N'})
        .then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;        
      } else {
        check = false;
      }
    });
    return check;    
  }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
        backgroundColor: const Color.fromARGB(255, 51, 201, 21),
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
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: productCodeController,
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
                //Phân loại sản phẩm
                DropdownButtonFormField<String>(
                  value: productCategory,
                  decoration: InputDecoration(
                    labelText: 'Phân loại sản phẩm',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: '1',
                      child: Text('Điện tử'),
                    ),
                    DropdownMenuItem<String>(
                      value: '2',
                      child: Text('Thời trang'),
                    ),
                    DropdownMenuItem<String>(
                      value: '3',
                      child: Text('Thực phẩm'),
                    ),
                    DropdownMenuItem<String>(
                      value: '4',
                      child: Text('Đồ gia dụng'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      productCategory = newValue;
                      productCategoryController.text = newValue ?? '';
                      print(productCategoryController.text);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn phân loại sản phẩm';
                    }
                    return null;
                  },
                  hint: const Text('Chọn phân loại sản phẩm'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    hintText: 'Nhập tên sản phẩm',
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
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả sản phẩm',
                    hintText: 'Nhập mô tả sản phẩm',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: productPriceController,
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
                const SizedBox(height: 24),              
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Add logic to save the new product
                      _addProduct(productCodeController.text, productCategoryController.text, productNameController.text, productDescriptionController.text, double.parse(productPriceController.text)).then((value) {
                        print(value);
                        if (value) {
                         AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          title: 'Thông báo',
                          desc: 'Thêm sản phẩm thành công',
                          btnOkOnPress: () {
                            Get.back();
                          },
                          btnCancelText: 'Cancel',
                          btnOkText: 'OK',
                         ).show();
                        }
                        else {
                          AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: 'Thông báo',
                          desc: 'Thêm sản phẩm thất bại',
                            btnOkOnPress: () {
                            Get.back();
                          },
                          btnCancelOnPress: () {
                            Get.back();
                          },
                          btnOkText: 'OK',
                          btnCancelText: 'Cancel',
                         ).show();
                        } 
                      }); 
                    }
                  },
                  child: const Text('Lưu sản phẩm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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