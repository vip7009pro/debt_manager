import 'package:flutter/material.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({ Key? key }) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual invoice count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Invoice #${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
            trailing: Text('\$${(index + 1) * 100}'),
            onTap: () {
              // Add logic to view invoice details
            },
          );
        },
      ),
    );
  }
}