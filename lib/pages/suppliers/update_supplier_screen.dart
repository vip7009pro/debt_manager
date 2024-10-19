import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:flutter/material.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:get/get.dart';

class UpdateSupplierScreen extends StatefulWidget {
  final Vendor supplier;

  const UpdateSupplierScreen({Key? key, required this.supplier}) : super(key: key);

  @override
  _UpdateSupplierScreenState createState() => _UpdateSupplierScreenState();
}

class _UpdateSupplierScreenState extends State<UpdateSupplierScreen> {
  final TextEditingController _supplierCodeController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _supplierAddressController = TextEditingController();
  final TextEditingController _supplierPhoneController = TextEditingController();
  final GlobalController c = Get.put(GlobalController());
  @override
  void initState() {
    super.initState();
    _supplierCodeController.text = widget.supplier.vendorCode;
    _supplierNameController.text = widget.supplier.vendorName;
    _supplierAddressController.text = widget.supplier.vendorAdd;
    _supplierPhoneController.text = widget.supplier.vendorPhone;
  }

  Future<bool> _updateSupplier() async {
    bool check = false;
    String shopID = c.shopID.value;
    await API_Request.api_query('updateVendor', {
      'SHOP_ID': shopID,
      'VENDOR_CODE': _supplierCodeController.text,
      'VENDOR_NAME': _supplierNameController.text,
      'VENDOR_ADD': _supplierAddressController.text,
      'VENDOR_PHONE': _supplierPhoneController.text
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
      }
    });
    return check;
  }
  Future<bool> _deleteSupplier(String vendorCode) async {
    bool check = false;
    String shopID = c.shopID.value;
    await API_Request.api_query('deleteVendor', {
      'SHOP_ID': shopID,
      'VENDOR_CODE': vendorCode
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;
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
        title: const Text('Update Supplier'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                title: 'Delete Supplier',
                desc: 'Are you sure you want to delete this supplier?',
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  bool check = await _deleteSupplier(widget.supplier.vendorCode);
                  if (check) {
                    Get.back(result: true);
                  } else {
                    AwesomeDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      dialogType: DialogType.error,
                      title: 'Failed to delete supplier',
                      btnOkOnPress: () {},
                    ).show();
                  }
                },
              ).show();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _supplierCodeController,
                decoration: const InputDecoration(
                  labelText: 'Supplier Code',
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierNameController,
                decoration: const InputDecoration(
                  labelText: 'Supplier Name',
                  hintText: 'Enter supplier name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierAddressController,
                decoration: const InputDecoration(
                  labelText: 'Supplier Address',
                  hintText: 'Enter supplier address',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Supplier Phone',
                  hintText: 'Enter supplier phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  bool check = await _updateSupplier();
                  if (check) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      title: 'Supplier updated successfully',
                      btnOkOnPress: () {
                        Get.back(result: true);
                      },
                    ).show();
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      title: 'Failed to update supplier',
                      desc: 'Please check the supplier information',
                      btnOkOnPress: () {},
                    ).show();
                  }
                },
                child: const Text('Update Supplier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
