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
      body: ListView.builder(
        itemCount: 10, // Replace with actual coupon count
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Coupon ${index + 1}'),
            subtitle: Text('Discount: ${(index + 1) * 5}%'),
            trailing: Text('Code: COUP${index + 1}'),
            onTap: () {
              // Add logic to view coupon details
            },
          );
        },
      ),
    );
  }
}