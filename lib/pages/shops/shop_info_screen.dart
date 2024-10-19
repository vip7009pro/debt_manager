import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ShopInfoScreen extends StatefulWidget {
  const ShopInfoScreen({ Key? key }) : super(key: key);

  @override
  _ShopInfoScreenState createState() => _ShopInfoScreenState();
}

class _ShopInfoScreenState extends State<ShopInfoScreen> {
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopDescrController = TextEditingController();
  TextEditingController shopAddController = TextEditingController();
  TextEditingController shopAvatarController = TextEditingController();
  
  final GlobalController c = Get.put(GlobalController());
  Shop shop = Shop(
      shopId: 0,
      uid: '',
      shopName: '',
      shopDescr: '',
      shopAdd: '',
      insDate: DateTime.now(),
      insUid: '',
      updDate: DateTime.now(),
      updUid: '',
      shopAvatar: '');

  Future<void> _getShopInfo() async {
    List<dynamic> shopList = [];
    await API_Request.api_query('getShopInfo', {
      'SHOP_ID': c.shopID.value == ''
          ? await LocalDataAccess.getVariable('shopId')
          : c.shopID.value
    }).then((value) {
      shopList = value['data'] ?? [];
      setState(() {
        if (shopList.isNotEmpty) {
          shop = Shop.fromJson(shopList[0]);          
          shopNameController.text = shop.shopName;
          shopDescrController.text = shop.shopDescr;
          shopAddController.text = shop.shopAdd;
          shopAvatarController.text = shop.shopAvatar;
        }
      });
    });
  }
  Future<void> _updateShopInfo() async {
    
    await API_Request.api_query('updateShopInfo', {
      'SHOP_ID': c.shopID.value == ''
          ? await LocalDataAccess.getVariable('shopId')
          : c.shopID.value,
      'SHOP_NAME': shopNameController.text,
      'SHOP_DESCR': shopDescrController.text,
      'SHOP_ADD': shopAddController.text,
      'SHOP_AVATAR': shopAvatarController.text
    }).then((value) {
      if (value['tk_status'] == 'OK') {        
        AwesomeDialog(  
          context: context,
          dialogType: DialogType.success,
          title: 'Success',
          btnOkOnPress: () {
            Get.back();
          },  
          body: Text('Shop info updated successfully'),
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          btnOkOnPress: () {
            
          },
          body: Text('Failed to update shop info'),
        ).show();
      }
    });
  }
  void _uploadImage() async {    
    if (shopAvatarController.text.isNotEmpty && File(shopAvatarController.text).existsSync()) {      
      try {
        final result = await API_Request.uploadQuery(
          file: File(shopAvatarController.text),
          filename: '${await LocalDataAccess.getVariable('shopId')}.jpg',
          uploadfoldername: 'shop_avatars',
        );
        if (result['tk_status'] == 'OK') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully')),
          );
          // Update the shopAvatarController with the new URL if provided in the result
          if (result['url'] != null) {
            setState(() {
              shopAvatarController.text = result['url'];
            });
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
  void initState() {
    _getShopInfo();
    super.initState();
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(              
              controller: shopNameController,
              onChanged: (value) {                
                shopNameController.text = value;
              },
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            TextFormField(
              controller: shopDescrController,
              onChanged: (value) {
                shopDescrController.text = value;
              },
              decoration: const InputDecoration(labelText: 'Shop Description'),
            ),
            TextFormField(
              controller: shopAddController,
              onChanged: (value) {
                shopAddController.text = value;
              },
              decoration: const InputDecoration(labelText: 'Shop Address'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,  
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        shopAvatarController.text = pickedImage.path;
                      });
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: shopAvatarController.text.isNotEmpty
                        ? Image.file(
                            File(shopAvatarController.text),
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 30,
                                height: 30,
                                color: Colors.grey[300],
                                child: Icon(Icons.store, color: Colors.grey[600]),
                              );
                            },
                          )
                        : Image.network(
                            "http://14.160.33.94:3010/shop_avatars/${shop.shopId}.jpg",
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {                 
                              return Container(
                                width: 30,
                                height: 30,
                                color: Colors.grey[300],
                                child: Icon(Icons.store, color: Colors.grey[600]),
                              );
                            },
                          ),
                  )
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    _uploadImage();
                  },
                  child: const Text('Upload Image'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _updateShopInfo();                 
                  },
                  child: const Text('Update Shop Info'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}