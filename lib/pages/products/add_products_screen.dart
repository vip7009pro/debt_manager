import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/features/barcode_scanner/barcode_scanner_pageview.dart';
import 'package:debt_manager/features/barcode_scanner/barcode_scanner_window.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({Key? key}) : super(key: key);
  @override
  _AddProductsScreenState createState() => _AddProductsScreenState();
}
class _AddProductsScreenState extends State<AddProductsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? productCategory;
  String? productCategoryId;  
  String? productName;
  String? productDescription;
  double? productPrice;
  String? productCode;
  Category? selectedCategory;
  final productCategoryController = TextEditingController();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productCodeController = TextEditingController();
  final GlobalController c = Get.put(GlobalController());
  MobileScannerController cameraController = MobileScannerController();
    List<Category> categories = [];
  //create random product code contains letter and number of length 10
     Future<List<Category>> _getCategories() async {
    List<dynamic> categoryList = [];
    await API_Request.api_query('getCategoryList', {'SHOP_ID': c.shopID.value})
        .then((value) {
      categoryList = value['data'] ?? [];
    });
    return categoryList.map((dynamic item) {
      return Category.fromJson(item);
    }).toList();
  }

  void _getCategoryList() async {
    await _getCategories().then((value) {
      setState(() {
        categories = value;        
      });
    });
  }
  
  String createRandomProductCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (_) => chars[Random().nextInt(chars.length)])
        .join('');
  }
  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        productCodeController.text = barcodes.barcodes.firstOrNull?.rawValue ?? '';
        cameraController.stop();
      });
    }
  }
  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }
    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }
  Future<bool> _addProduct(
      String productCode,
      String catId,
      String productName,
      String productDescription,
      String catCode,
      double productPrice) async {
    // Add product logic here
    bool check = true;
    int shopID = c.shopID.value;
    await API_Request.api_query('addNewProduct', {
      'PROD_CODE': productCode,
      'CAT_ID': catId,
      'CAT_CODE': catCode,
      'PROD_NAME': productName,
      'PROD_DESCR': productDescription,
      'PROD_PRICE': productPrice,
      'SHOP_ID': shopID,
      'PROD_IMG': 'N'
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      } else {
        check = false;
      }
    });
    return check;
  }
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
    productCodeController.text = createRandomProductCode();
    _getCategoryList(); 
  }
  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    ),
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        final result = await Get.to(() => BarcodeScannerWithScanWindow());
                        if (result != null) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            title: 'Thông báo',
                            desc: '${result.rawValue}',
                            btnOkOnPress: () {
                              Get.back();
                            },
                            btnCancelText: 'Cancel',
                            btnOkText: 'OK',
                          ).show(); 

                          setState(() {
                            productCodeController.text = result.rawValue ?? '';
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                //Phân loại sản phẩm
                FutureBuilder<List<Category>>(
                  future: _getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No categories available');
                    } else {
                      return DropdownButtonFormField<String>(
                        value: productCategoryId,
                        decoration: InputDecoration(
                          labelText: 'Phân loại sản phẩm',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem<String>(
                            value: category.catId.toString(),
                            child: Text(category.catName),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            productCategoryId = newValue;
                            selectedCategory = snapshot.data!.firstWhere((category) => category.catId.toString() == newValue);
                            productCategory = selectedCategory?.catCode;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng chọn phân loại sản phẩm';
                          }
                          return null;
                        },
                        hint: const Text('Chọn phân loại sản phẩm'),
                      );
                    }
                  },
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
                      _addProduct(
                        productCodeController.text, 
                        productCategoryId!,
                        productNameController.text,
                        productDescriptionController.text,
                        productCategory!,
                        double.parse(productPriceController.text))
                          .then((value) {
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
                        } else {
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
                    foregroundColor: Colors.white,
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
