import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../products/product_details.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';


class StockScreen extends StatefulWidget {
  const StockScreen({ Key? key }) : super(key: key);

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual product count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Product ${index + 1}'),
            subtitle: Text('Description of Product ${index + 1}'),
            trailing: Text('Stock: ${(index + 1) * 5}'), // Example stock count
            onTap: () {
              // Add logic to view product stock details
              Get.to(() => ProductDetails(product: Product(prodId: 0, shopId: 0, prodName: '', prodDescr: '', prodPrice: 0, insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', catId: 0, prodCode: '', prodImg: '')));
            },
          );
        },
      ),
    );
  }
}