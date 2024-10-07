import 'package:flutter/material.dart';

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
      body: Container(
        // Your content here
        child: Text("Stock"),
      ),
    );
  }
}