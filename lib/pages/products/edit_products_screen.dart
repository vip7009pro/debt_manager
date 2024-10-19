import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';  
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class EditProductsScreen extends StatefulWidget {
  final Product product;
  const EditProductsScreen({Key? key, required this.product}) : super(key: key);
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? productCategory;
  String? productCategoryId;  
  String? productName;
  String? productDescription;
  double? productPrice;
  String? productCode;
  Category? selectedCategory; 
  List<String> locallyAddedImages = [];
  late List<String> serverImages;
  final productCategoryController = TextEditingController();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productCodeController = TextEditingController();
  final GlobalController c = Get.put(GlobalController());

  // Color palette
  final Color primaryColor = Colors.purple;
  final Color secondaryColor = Colors.orange;
  final Color accentColor = Colors.teal;
  final Color backgroundColor = Colors.yellow[50]!;
  final Color textColor = Colors.indigo;

  String createRandomProductCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (_) => chars[Random().nextInt(chars.length)])
        .join('');
  }

  List<Category> categories = [];
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
        productCategoryId = widget.product.catId.toString();  
        //set selected category  to the category that has the same catID as widget.product.catId  
        selectedCategory = categories.where((category) => category.catId == widget.product.catId).first;  
      });
    });
  }


  Future<bool> _editProduct(
      String productCode,
      String productCategory,
      String productName,
      String productDescription,
      double productPrice) async {
    // Add product logic here
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('editProduct', {
      'PROD_CODE': productCode,
      'CAT_ID': productCategory,
      'PROD_NAME': productName,
      'PROD_DESCR': productDescription,
      'PROD_PRICE': productPrice,
      'SHOP_ID': shopID,
      'PROD_IMG': 'N'
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
        _deleteProduct(productCode, widget.product.prodImg);  
        _uploadImage();
      } else {
        check = false;
      }
    });
    return check;
  }

  Future<bool> _updateProductImage(String productCode, String productImg) async {
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('updateProductImage', {
      'PROD_CODE': productCode,
      'SHOP_ID': shopID,
      'PROD_IMG': productImg
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      } else {
        check = false;
      }
    });
    return check;
  }

  Future<bool> _deleteProduct(String productCode, String productImg) async {
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('deleteProductImage', {
      'PROD_CODE': productCode,
      'SHOP_ID': shopID,
      'PROD_IMG': productImg 
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      } else {
        check = false;
      }
    });
    return check;
  }

  void _uploadImage() async {
    List<String> allImages = locallyAddedImages + serverImages; 
    print('allImages: $allImages'); 

    for (int i = 0; i < allImages.length; i++) {
      String image = allImages[i];
      print('image: ' + image);
      if (image.isNotEmpty) {
        try {
          File imageFile;
          if (image.startsWith('http://') || image.startsWith('https://')) {            
            final response = await http.get(Uri.parse(image));
            final bytes = response.bodyBytes;
            final tempDir = await getTemporaryDirectory();
            final tempFile = File('${tempDir.path}/temp_image_$i.jpg'); 
            await tempFile.writeAsBytes(bytes);
            imageFile = tempFile;
          } else {            
            imageFile = File(image);
          }

          final result = await API_Request.uploadQuery(
            file: imageFile,
            filename: '${await LocalDataAccess.getVariable('shopId')}_${productCodeController.text}_$i.jpg',
            uploadfoldername: 'product_images',
          );
          if (result['tk_status'] == 'OK') {
            print('result: $result');            
          } else {
            print('Error uploading image: ${result['message']}');
          }
        } catch (e) {
          print('Error uploading image: $e');          
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please choose a valid image', style: TextStyle(color: textColor))),
        );
      }
    }    
    await _updateProductImage(productCodeController.text, List.generate(allImages.length, (index) => index.toString()).join(','));
  }

  @override
  void initState() {
    super.initState();
    productCodeController.text = widget.product.prodCode;
    productCategoryController.text = widget.product.catId.toString();
    productNameController.text = widget.product.prodName; 
    productDescriptionController.text = widget.product.prodDescr;
    productPriceController.text = widget.product.prodPrice.toString();
    productCategory = widget.product.catId.toString();
    serverImages = widget.product.prodImg.split(',').map((element) => 'http://14.160.33.94:3010/product_images/${c.shopID.value}_${productCodeController.text}_$element.jpg').toList();
    _getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    final addProductImageWidget = Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.photo_library, color: accentColor),
                          title: Text('Choose from gallery', style: TextStyle(color: textColor)),
                          onTap: () async {
                            Navigator.pop(context);
                            final List<XFile>? images =
                                await ImagePicker().pickMultiImage();
                            if (images != null) {
                              setState(() {
                                locallyAddedImages
                                    .addAll(images.map((image) => image.path));
                                serverImages.clear();
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_camera, color: accentColor),
                          title: Text('Take a photo', style: TextStyle(color: textColor)),
                          onTap: () async {
                            Navigator.pop(context);
                            final XFile? image = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (image != null) {
                              setState(() {
                                locallyAddedImages.add(image.path);
                                serverImages.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text('Add', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: secondaryColor,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...serverImages.asMap().entries.map((entry) {                
                return Stack(
                  children: [
                    Container(
                      width: 120,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(entry.value),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: accentColor, width: 2),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            serverImages.removeAt(entry.key);
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
              ...locallyAddedImages
                  .asMap()
                  .entries
                  .map((entry) => Stack(
                        children: [
                          Container(
                            width: 120,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(entry.value)),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: accentColor, width: 2),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 10,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  locallyAddedImages.removeAt(entry.key);
                                });
                              },
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa sản phẩm', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
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
                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Category>>(
                future: _getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: primaryColor);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: TextStyle(color: textColor));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No categories available', style: TextStyle(color: textColor));
                  } else {
                    return DropdownButtonFormField<String>(
                      value: productCategoryId,
                      decoration: InputDecoration(
                        labelText: 'Phân loại sản phẩm',
                        labelStyle: TextStyle(color: textColor),
                        hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: accentColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                      dropdownColor: backgroundColor,
                      style: TextStyle(color: textColor),
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
                      hint: Text('Chọn phân loại sản phẩm', style: TextStyle(color: textColor.withOpacity(0.6))),
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
                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: productDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Mô tả sản phẩm',
                  hintText: 'Nhập mô tả sản phẩm',
                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                maxLines: 3,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: productPriceController,
                decoration: InputDecoration(
                  labelText: 'Giá sản phẩm',
                  hintText: 'Nhập giá sản phẩm',
                  labelStyle: TextStyle(color: textColor),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              addProductImageWidget,
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add logic to save the new product
                    _editProduct(
                            productCodeController.text,
                            productCategoryController.text,
                            productNameController.text,
                            productDescriptionController.text,
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
                            
                            //Get.back();
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
                child: const Text('Update'),
              ),
              //deleteProductButton 
              ElevatedButton(
                onPressed: () {
                  // Add logic to delete the product
                  _deleteProduct(productCodeController.text, widget.product.prodImg).then((value) {
                    if (value) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        title: 'Thông báo',
                        desc: 'Xóa sản phẩm thành công',
                      ).show();
                    }
                  }); 
                },
                child: const Text('Delete'),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}
