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
  String? productName;
  String? productDescription;
  double? productPrice;
  String? productCode;
  List<String> locallyAddedImages = [];
  late List<String> serverImages;
  final productCategoryController = TextEditingController();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productCodeController = TextEditingController();
  final GlobalController c = Get.put(GlobalController());
  //create random product code contains letter and number of length 10
  String createRandomProductCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (_) => chars[Random().nextInt(chars.length)])
        .join('');
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
        _uploadImage();
      } else {
        check = false;
      }
    });
    return check;
  }
  Future<bool> _updateProductImage(String productCode, String productImg) async {
    // Add product logic here
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
            // download image from image link
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
          SnackBar(content: Text('Please choose a valid image')),
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
    print(widget.product.prodImg);  
    serverImages = widget.product.prodImg.split(',').map((element) => 'http://14.160.33.94:3010/product_images/${c.shopID.value}_${productCodeController.text}_$element.jpg').toList();
  }
  @override
  Widget build(BuildContext context) {
    final addProductImageWidget = Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: ElevatedButton(
            onPressed: () {
              // Add logic to pick and add a new image
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Choose from gallery'),
                          onTap: () async {
                            Navigator.pop(context);
                            final List<XFile>? images =
                                await ImagePicker().pickMultiImage();
                            if (images != null) {
                              setState(() {
                                locallyAddedImages
                                    .addAll(images.map((image) => image.path));
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_camera),
                          title: Text('Take a photo'),
                          onTap: () async {
                            Navigator.pop(context);
                            final XFile? image = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (image != null) {
                              setState(() {
                                locallyAddedImages.add(image.path);
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
            child: Text('Add'),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Existing server images
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
              // Locally added images
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
        title: const Text('Sửa sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: productCodeController,
                decoration: const InputDecoration(
                  labelText: 'Mã sản phẩm',
                  hintText: 'Nhập mã sản phẩm',
                ),
              ),
              const SizedBox(height: 16),
              //Phân loại sản phẩm
              DropdownButtonFormField<String>(
                value: productCategory,
                decoration: const InputDecoration(
                  labelText: 'Phân loại sản phẩm',
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
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm',
                  hintText: 'Nhập tên sản phẩm',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: productDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả sản phẩm',
                  hintText: 'Nhập mô tả sản phẩm',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: productPriceController,
                decoration: const InputDecoration(
                  labelText: 'Giá sản phẩm',
                  hintText: 'Nhập giá sản phẩm',
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
            ],
          ),
        ),
      ),
    );
  }
}
