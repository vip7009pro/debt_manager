import 'package:flutter/material.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  String shopid = '';

  @override
  void initState() {
    super.initState();  
      LocalDataAccess.getVariable('shopid').then((value) {
        setState(() {
          shopid = value;
        });
      });  
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Home Page $shopid'),
      ),
      body: Center(
        child: Text(shopid.toString()),
      ),
    );
  }
}