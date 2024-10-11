import 'dart:math';

import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomersScreen extends StatefulWidget {
  const AddCustomersScreen({ Key? key }) : super(key: key);

  @override
  _AddCustomersScreenState createState() => _AddCustomersScreenState();
}

class _AddCustomersScreenState extends State<AddCustomersScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalController c = Get.put(GlobalController());

  final TextEditingController _cusNameController = TextEditingController();
  final TextEditingController _cusPhoneController = TextEditingController();
  final TextEditingController _cusEmailController = TextEditingController();
  final TextEditingController _cusAddController = TextEditingController();
  final TextEditingController _cusLocController = TextEditingController();
  final TextEditingController _custCdController = TextEditingController();

  Future<void> _addCustomer() async {
    try {
      final response = await API_Request.api_query('addNewCustomer', {
        'SHOP_ID': c.shopID.value,
        'CUS_NAME': _cusNameController.text,
        'CUS_PHONE': _cusPhoneController.text,
        'CUS_EMAIL': _cusEmailController.text,
        'CUS_ADD': _cusAddController.text,
        'CUS_LOC': _cusLocController.text,
        'CUST_CD': _custCdController.text,
      });

      if (response['tk_status'] == 'OK') {
        Get.back();
        Get.snackbar('Success', 'Customer added successfully');
      } else {
        Get.snackbar('Error', 'Failed to add customer');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  //generate random customer code contains letter and number of length 15
  String generateRandomCustomerCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(15, (_) => chars[Random().nextInt(chars.length)]).join('');
  } 

  @override
  void initState() {
    super.initState();
    _custCdController.text = generateRandomCustomerCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm khách hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              //Mã khách hàng
              TextFormField(
                controller: _custCdController,
                decoration: const InputDecoration(
                  labelText: 'Mã khách hàng',
                  hintText: 'Nhập mã khách hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cusNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên khách hàng',
                  hintText: 'Nhập tên khách hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cusPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  hintText: 'Nhập số điện thoại khách hàng',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cusEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Nhập email khách hàng',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cusAddController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  hintText: 'Nhập địa chỉ khách hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cusLocController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  hintText: 'Nhập địa chỉ khách hàng',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {  
                    _addCustomer(); 
                  }
                },
                child: const Text('Lưu khách hàng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}