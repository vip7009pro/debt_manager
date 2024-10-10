import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({ Key? key, required this.product }) : super(key: key);

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
      body: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product.prodName),
            Text(widget.product.prodDescr),
            Text('\$${widget.product.prodPrice}'),
            ElevatedButton(onPressed: () {
             
            }, child: Text('Add to Cart')), 
          ],
        ),
      ),
    );
  }
}