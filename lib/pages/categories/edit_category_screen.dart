import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category selectedCategory;

  const EditCategoryScreen({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final GlobalController c = Get.find<GlobalController>();
  late TextEditingController catCodeController;
  late TextEditingController catNameController;
  late TextEditingController catImageController;
  String imagepath = '';

  @override
  void initState() {
    super.initState();
    catCodeController = TextEditingController(text: widget.selectedCategory.catCode);
    catNameController = TextEditingController(text: widget.selectedCategory.catName);
    catImageController = TextEditingController(text: widget.selectedCategory.shopId.toString() + '_' + widget.selectedCategory.catCode.toString() + '.jpg');
  }

  Future<bool> _updateCategory(String catCode, String catName) async {
    bool check = false;
    int shopID = c.shopID.value;
    await API_Request.api_query('updateCategory', {
      'CAT_CODE': catCode,
      'CAT_NAME': catName,
      'SHOP_ID': shopID,
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      }
    });
    return check;
  }

  Future<bool> _deleteCategory(String catCode) async {
    bool check = false;
    int shopID = c.shopID.value;
    await API_Request.api_query('deleteCategory', {
      'CAT_CODE': catCode,
      'SHOP_ID': shopID,
    }).then((value) {
      if (value['tk_status'] == 'OK') { 
        check = true;
      }
    });
    return check;
  } 

  void _uploadImage() async {    
    if (imagepath.isNotEmpty && File(imagepath).existsSync()) {      
      try {
        final result = await API_Request.uploadQuery(
          file: File(imagepath),
          filename: catImageController.text,
          uploadfoldername: 'category_images',
        );
        if (result['tk_status'] == 'OK') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully')),
          );
          // Update the shopAvatarController with the new URL if provided in the result
          if (result['url'] != null) {
           
          } 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: ${result['message']}')),
          );
        }
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while uploading the image')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose an image first')),
      );
    }
  } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa danh mục'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: catCodeController,
                decoration: InputDecoration(
                  labelText: 'Mã danh mục',
                ),
                readOnly: true,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: catNameController,
                decoration: InputDecoration(
                  labelText: 'Tên danh mục',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên danh mục';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              //select image from gallery
              GestureDetector(
                onTap: () async {
                  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        imagepath = pickedImage.path;
                      });
                    }
                },
                  child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child:imagepath.isNotEmpty ?  Image.file(
                      File(imagepath),
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 30,
                          height: 30,
                          color: Colors.grey[300],
                          child: Icon(Icons.category, color: Colors.grey[600]),
                        );
                      },
                    ) :  
                    Image.network(
                      'http://14.160.33.94:3010/category_images/${catImageController.text}',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    )
                  ),  
              ),
              SizedBox(height: 16),
              //upload image button 
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: Text('Upload Image'),
              ),
              SizedBox(height: 16), 
              ElevatedButton(
                onPressed: () {
                  _updateCategory(catCodeController.text, catNameController.text).then((value) {
                    if (value) {
                      AwesomeDialog(
                        context: context,
                        title: 'Thông báo',
                        desc: 'Cập nhật danh mục thành công',
                        btnOkOnPress: () {
                          Get.back(result: true);
                        },
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        title: 'Thông báo',
                        desc: 'Cập nhật danh mục thất bại',
                        btnOkOnPress: () {},
                      ).show();
                    }
                  });
                },
                  child: Text('Update'),
                ),
                //delete category button
                ElevatedButton(
                  onPressed: () {
                    //awesome dialog confirm before delete
                    AwesomeDialog(
                      context: context,
                      title: 'Thông báo',
                      desc: 'Bạn có chắc chắn muốn xóa danh mục này không?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        _deleteCategory(catCodeController.text).then((value) {
                          if (value) {
                            Get.back();
                          }
                        }); 
                      },
                    ).show(); 
                  },  
                  child: Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    catCodeController.dispose();
    catNameController.dispose();
    super.dispose();
  }
}
