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
      body: ListView.builder(
        itemCount: 10, // Replace with actual supplier count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.business),
            title: Text('Supplier ${index + 1}'),
            subtitle: Text('Contact: supplier${index + 1}@example.com'),
            trailing: Text('ID: SUP${index + 1}'),
            onTap: () {
              // Add logic to view supplier details
            },
          );
        },
      ),
    );
  }
}