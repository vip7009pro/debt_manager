import 'package:flutter/material.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({ Key? key }) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier'),
      ),
      body: Center(
        child: Text("Supplier"),
      ),
    );
  }
}