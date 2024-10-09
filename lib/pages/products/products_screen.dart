import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_details.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({ Key? key }) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual product count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Product ${index + 1}'),
            subtitle: Text('Description of Product ${index + 1}'),
            trailing: Text('\$${(index + 1) * 10}'),
            onTap: () {
              // Add logic to view product details
              Get.to(() => ProductDetails());
            },
          );
        },
      ),
    );
  }
}