import 'package:flutter/material.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({ Key? key }) : super(key: key);

  @override
  _WarehouseScreenState createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Warehouse'),),
      body: ListView.builder(
        itemCount: 10, // Replace with actual product input history count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Product Input ${index + 1}'),
            subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
            trailing: Text('Quantity: ${(index + 1) * 10}'),
            onTap: () {
              // Add logic to view detailed input history
            },
          );
        },
      ),
    );  
  }
}