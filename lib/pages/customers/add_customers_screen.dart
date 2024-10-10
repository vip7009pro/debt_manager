import 'package:flutter/material.dart';

class AddCustomersScreen extends StatefulWidget {
  const AddCustomersScreen({ Key? key }) : super(key: key);

  @override
  _AddCustomersScreenState createState() => _AddCustomersScreenState();
}

class _AddCustomersScreenState extends State<AddCustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm khách hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              //Mã khách hàng
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mã khách hàng',
                  hintText: 'Nhập mã khách hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tên khách hàng',
                  hintText: 'Nhập tên khách hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  hintText: 'Nhập số điện thoại khách hàng',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Nhập email khách hàng',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  hintText: 'Nhập địa chỉ khách hàng',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  hintText: 'Nhập địa chỉ khách hàng',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Add logic to save the new customer
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