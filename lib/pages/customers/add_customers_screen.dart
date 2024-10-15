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
        Get.snackbar('Success', 'Customer added successfully', 
          backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed to add customer', 
          backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', 
        backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

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
        title: const Text('Thêm khách hàng', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 147, 114, 240),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[100]!, Colors.purple[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _custCdController,
                  decoration: InputDecoration(
                    labelText: 'Mã khách hàng',
                    hintText: 'Nhập mã khách hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cusNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên khách hàng',
                    hintText: 'Nhập tên khách hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cusPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại khách hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cusEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Nhập email khách hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cusAddController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ',
                    hintText: 'Nhập địa chỉ khách hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cusLocController,
                  decoration: InputDecoration(
                    labelText: 'Vị trí',
                    hintText: 'Nhập vị trí khách hàng',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {  
                      _addCustomer(); 
                    }
                  },
                  child: const Text('Lưu khách hàng', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}