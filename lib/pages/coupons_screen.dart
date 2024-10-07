import 'package:flutter/material.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({ Key? key }) : super(key: key);

  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons'),
      ),
      body: Center(
        child: Text('Coupons'),
      ),
    );
  }
}