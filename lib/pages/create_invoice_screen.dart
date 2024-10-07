import 'package:flutter/material.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({ Key? key }) : super(key: key);

  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Invoice"),
      ),
      body: Center(
        child: Text("Create Invoice"),
      ),
    );
  }
}