import 'package:debt_manager/controller/APIRequest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class AddShopPage extends StatefulWidget {
  const AddShopPage({ super.key });
  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _shopDescriptionController = TextEditingController();
  Future<bool> _addShop(String shopName, String shopAddress, String shopDescription) async {
    // Add shop logic here
    bool check = true;
    await API_Request.api_query('addNewShop', {'SHOP_NAME': shopName, 'SHOP_ADD': shopAddress, 'SHOP_DESCR': shopDescription})
        .then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;        
      } else {
        check = false;
      }
    });
    return check;    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _shopNameController,
                decoration: const InputDecoration(
                  labelText: 'Shop Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _shopAddressController,
                decoration: const InputDecoration(
                  labelText: 'Shop Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
               TextField(
                controller: _shopDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Shop Description',
                  border: OutlineInputBorder(),
                ),
              ),


              ElevatedButton(
                onPressed: () async {
                  // Add shop logic here
                  bool check = await _addShop(_shopNameController.text, _shopAddressController.text, _shopDescriptionController.text);
                  if (check) {
                    AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    title: 'Shop Added',
                    desc: 'Shop has been added successfully',
                    btnOkOnPress: () {                     
                      Get.back(result: true);
                    },
                  ).show();
                  } else {
                    AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    title: 'Shop Added',
                    desc: 'Shop has been added failed',
                    btnOkOnPress: () {
                      //Get.back();
                    },
                  ).show();
                  }
                },
                child: const Text('Add Shop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
