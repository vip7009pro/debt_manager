import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/controller/GetXController.dart';

class UpdateCustomerScreen extends StatefulWidget {
  final Customer customer;

  const UpdateCustomerScreen({Key? key, required this.customer}) : super(key: key);

  @override
  _UpdateCustomerScreenState createState() => _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends State<UpdateCustomerScreen> {
  final GlobalController c = Get.find<GlobalController>();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.cusName);
    _phoneController = TextEditingController(text: widget.customer.cusPhone);
    _emailController = TextEditingController(text: widget.customer.cusEmail);
    _addressController = TextEditingController(text: widget.customer.cusAdd);
    _locationController = TextEditingController(text: widget.customer.cusLoc);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      try {
        await API_Request.api_query('updateCustomer', {
          'SHOP_ID': c.shopID.value,
          'CUS_ID': widget.customer.cusId,
          'CUS_NAME': _nameController.text,
          'CUS_PHONE': _phoneController.text,
          'CUS_EMAIL': _emailController.text,
          'CUS_ADD': _addressController.text,
          'CUS_LOC': _locationController.text,
        });
        Get.back(result: true);
      } catch (e) {
        Get.snackbar('Error', 'Failed to update customer: $e');
      }
    }
  }

  Future<void> _deleteCustomer() async {
    try {
      await API_Request.api_query('deleteCustomer', {
        'SHOP_ID': c.shopID.value,
        'CUS_ID': widget.customer.cusId,
      });
      Get.back(result: true);
    } catch (e) { 
      Get.snackbar('Error', 'Failed to delete customer: $e');
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Customer', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 82, 176),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _updateCustomer,
                      child: Text('Update Customer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement delete customer functionality
                        //AwesomeDialog to confirm for delete
                        AwesomeDialog(
                          context: context,
                          title: 'Delete Customer',
                          body: Text('Are you sure you want to delete this customer?'),
                          buttonsTextStyle: TextStyle(color: Colors.white),
                          dialogType: DialogType.warning,
                          showCloseIcon: true,
                          btnCancelOnPress: () {
                            //Get.back();
                          },
                          btnOkOnPress: _deleteCustomer,
                        ).show();
                      },
                      child: Text('Delete Customer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
