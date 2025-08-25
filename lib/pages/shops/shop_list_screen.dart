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
  late Future<List<Shop>> _shopsFuture;
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
    super.initState();
    _shopsFuture = _getShopList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[100]!, Colors.purple[100]!],
          ),
        ),
        child: Center(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _shopsFuture = _getShopList();
              });
              await _shopsFuture;
            },
            child: FutureBuilder<List<Shop>>(
              future: _shopsFuture,
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.purple));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data', style: TextStyle(color: Colors.orange));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        color: Colors.white.withOpacity(0.9),
                        child: ListTile(
                          onTap: () {
                            LocalDataAccess.saveVariable('shopId', snapshot.data![index].shopId.toString());
                            c.shopID.value = int.parse(snapshot.data![index].shopId.toString());
                            Get.offAll(() => const HomePage());
                          },
                          title: Text(snapshot.data![index].shopName, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                          subtitle: Text(snapshot.data![index].shopDescr, style: TextStyle(color: Colors.teal)),
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
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(Icons.store, color: Colors.deepOrange),
                                );
                              },
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => const AddShopPage());
          if (result == true) {
            setState(() {
              _shopsFuture = _getShopList();
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),  
    );
  }
}
