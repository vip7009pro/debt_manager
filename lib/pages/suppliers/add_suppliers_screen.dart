import 'package:flutter/material.dart';

class AddSuppliersScreen extends StatefulWidget {
  const AddSuppliersScreen({ Key? key }) : super(key: key);

  @override
  _AddSuppliersScreenState createState() => _AddSuppliersScreenState();
}

class _AddSuppliersScreenState extends State<AddSuppliersScreen> {
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
                decoration: const InputDecoration(
                  labelText: 'Mã nhà cung cấp',
                  hintText: 'Nhập mã nhà cung cấp',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tên nhà cung cấp',
                  hintText: 'Nhập tên nhà cung cấp',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ nhà cung cấp',
                  hintText: 'Nhập địa chỉ nhà cung cấp',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại nhà cung cấp',
                  hintText: 'Nhập số điện thoại nhà cung cấp',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Add logic to save the new supplier
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