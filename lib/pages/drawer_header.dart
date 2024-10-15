import 'package:flutter/material.dart';

class DrawerHeaderTab extends StatefulWidget {
  const DrawerHeaderTab({super.key});

  @override
  _DrawerHeaderTabState createState() => _DrawerHeaderTabState();
}

class _DrawerHeaderTabState extends State<DrawerHeaderTab> {
  @override
  Widget build(BuildContext context) {
    var emplImage = ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/empty_avatar.png',
        image:
            "https://cdn.arttimes.vn/upload/4-2022/images/2022-11-16/hotgirl-nguc-khung-sinh-con-dau-long-duoc-vo-streamer-giau-nhat-viet-nam-tang-vang-sau-sinh-van-mon--hot-girl-sunna-an-thu-nay-sau-sinh-de-than-hinh-va-1668591342-759-width780height975.jpg",
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Container(            
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.store, color: Colors.purple[600]),
          );
        },
      ),
    );

    return Container(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[300]!, Colors.purple[300]!],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emplImage,
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.yellow[700]),
                  SizedBox(width: 4),
                  Text('Nguyễn Văn A', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.green[400]),
                  SizedBox(width: 4),
                  Text('hung1893@gmail.com', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.red[400]),
                  SizedBox(width: 4),
                  Text('0987654321', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
