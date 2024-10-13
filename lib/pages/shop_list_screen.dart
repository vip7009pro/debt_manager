import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:debt_manager/pages/shops/add_shop_page.dart';
import 'package:debt_manager/pages/home_page.dart';
import 'package:debt_manager/pages/shops/shop_home_page.dart';
import 'package:debt_manager/pages/shops/shop_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:get/get.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final GlobalController c = Get.put(GlobalController());
  Future<List<Shop>> _getShopList() async {
    List<dynamic> shopList = [];
    await API_Request.api_query('getShopList', {}).then((value) {
      shopList = value['data'] ?? [];
    });
    return shopList.map((dynamic item) {
      return Shop.fromJson(item);
    }).toList();
  }

  @override
  void initState() {
    _getShopList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop List'),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _getShopList();
            });
          },
          child: FutureBuilder<List<Shop>>(
          future: _getShopList(),
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      LocalDataAccess.saveVariable('shopid', snapshot.data![index].shopId.toString());
                      c.shopID.value = snapshot.data![index].shopId.toString();
                      Get.offAll(() => const HomePage());
                    },
                    title: Text(snapshot.data![index].shopName),
                    subtitle: Text(snapshot.data![index].shopDescr),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/empty_avatar.png',
                        image: "http://14.160.33.94:3010/shop_avatars/${snapshot.data![index].shopId}.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: Icon(Icons.store, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Get.to(() => const AddShopPage());
      },
      child: const Icon(Icons.add),
    ),  
    );
  }
}

