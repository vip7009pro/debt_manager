import 'package:flutter/material.dart';

class FullSreenImage extends StatefulWidget {
  final String imageUrl;

  FullSreenImage({required this.imageUrl});

  @override
  _FullSreenImageState createState() => _FullSreenImageState();
}

class _FullSreenImageState extends State<FullSreenImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(widget.imageUrl),
    );
  }
}