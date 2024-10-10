import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:get/get.dart'; 
class AddSuppliersScreen extends StatefulWidget {
  const AddSuppliersScreen({ Key? key }) : super(key: key);

  @override
  _AddSuppliersScreenState createState() => _AddSuppliersScreenState();
}

class _AddSuppliersScreenState extends State<AddSuppliersScreen> {
  final TextEditingController _supplierCodeController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _supplierAddressController = TextEditingController();
  final TextEditingController _supplierPhoneController = TextEditingController();

  Future<bool> _addSupplier(String SHOP_ID, String VENDOR_CODE, String VENDOR_NAME, String VENDOR_ADD, String VENDOR_PHONE) async {
    // Add supplier logic here
    bool check = true;
    await API_Request.api_query('addvendor', {      
      'SHOP_ID':'23',
      'VENDOR_CODE': VENDOR_CODE, // Using supplierId as VENDOR_CODE, adjust if different
      'VENDOR_NAME': VENDOR_NAME,
      'VENDOR_ADD': VENDOR_ADD,
      'VENDOR_PHONE': VENDOR_PHONE
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
    _supplierCodeController.dispose();
    _supplierNameController.dispose();
    _supplierAddressController.dispose();
    _supplierPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhà cung cấp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _supplierCodeController,
                decoration: const InputDecoration(
                  labelText: 'Mã nhà cung cấp',
                  hintText: 'Nhập mã nhà cung cấp',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên nhà cung cấp',
                  hintText: 'Nhập tên nhà cung cấp',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierAddressController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ nhà cung cấp',
                  hintText: 'Nhập địa chỉ nhà cung cấp',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại nhà cung cấp',
                  hintText: 'Nhập số điện thoại nhà cung cấp',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Add logic to save the new supplier
                  bool check = await _addSupplier( '23', _supplierCodeController.text, _supplierNameController.text, _supplierAddressController.text, _supplierPhoneController.text);  
                  if (check) {
                    AwesomeDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      dialogType: DialogType.success,
                      title: 'Thêm nhà cung cấp thành công',
                      btnOkOnPress: () {
                        Get.back(); // Close the dialog after adding  
                      },
                    ).show();
                  }
                  else {
                    AwesomeDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      dialogType: DialogType.error,
                      title: 'Thêm nhà cung cấp thất bại',
                      desc: 'Vui lòng kiểm tra lại thông tin nhà cung cấp',
                      btnOkOnPress: () {
                        //Get.back(); // Close the dialog after adding  
                      },
                    ).show();
                  } 
                },
                child: const Text('Lưu nhà cung cấp'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}