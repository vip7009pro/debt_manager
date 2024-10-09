import 'package:flutter/material.dart';
class MoreOptionsScreen extends StatefulWidget {
  const MoreOptionsScreen({ Key? key }) : super(key: key);

  @override
  _MoreOptionsScreenState createState() => _MoreOptionsScreenState();
}

class _MoreOptionsScreenState extends State<MoreOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Options'),
      ),
      body: Center(
        child: Text("More options"),
      ),
    );
  }
}