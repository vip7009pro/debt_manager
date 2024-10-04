import 'package:flutter/material.dart';

class DrawerHeaderTab extends StatefulWidget {
  const DrawerHeaderTab({super.key});

  @override
  _DrawerHeaderTabState createState() => _DrawerHeaderTabState();
}

class _DrawerHeaderTabState extends State<DrawerHeaderTab> {
  @override
  Widget build(BuildContext context) {
    const emplImage = CircleAvatar(
      radius: 30,
      backgroundImage:
          NetworkImage('http://14.160.33.94/Picture_NS/NS_NHU1903.jpg', scale: 0.5),
    );
    return const SizedBox(
      width: 100,
      height: 100,
      child: emplImage,
    );
  }
}
