import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({ Key? key }) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final GlobalController c = Get.put(GlobalController());
  TextEditingController catCodeController = TextEditingController();
  TextEditingController catNameController = TextEditingController();
  String createRandomCatCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(30, (_) => chars[Random().nextInt(chars.length)])
        .join('');
  }
  Future<bool> _addCategory(
      String catCode,
      String catName) async {
    // Add product logic here
    bool check = true;
    int shopID = c.shopID.value;
    await API_Request.api_query('addNewCategory', {
      'CAT_CODE': catCode,
      'CAT_NAME': catName,
      'SHOP_ID': shopID,
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      } else {
        check = false;
      }
    });
    return check;
  }

  void initState() {
    super.initState();
    catCodeController.text = createRandomCatCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm danh mục'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: catCodeController,
                decoration: InputDecoration(
                  labelText: 'Mã danh mục',
                  hintText: 'Mã sẽ được tự động tạo',
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
              ElevatedButton(
                onPressed: () {
                  _addCategory(catCodeController.text, catNameController.text).then((value) {
                    if (value) {
                      AwesomeDialog(
                        context: context,
                        title: 'Thông báo',
                        desc: 'Thêm danh mục thành công',
                        btnOkOnPress: () {
                          //Get.back();
                        },
                      ).show(); 
                    } else {
                        AwesomeDialog(
                        context: context,
                        title: 'Thông báo',
                        desc: 'Thêm danh mục thất bại',
                        btnOkOnPress: () {
                          //Get.back();
                        },
                      ).show();
                    }
                  });
                  // TODO: Implement save functionality
                  // This is where you would save the category
                  // including the generated fields like INS_DATE, INS_UID, UPD_DATE, UPD_UID
                },
                child: Text('Lưu danh mục'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}