import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({ Key? key }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Text('Product Details'),
      ),
    );
  }
}