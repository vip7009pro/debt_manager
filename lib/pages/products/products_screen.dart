import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'add_products_screen.dart';
import 'product_details.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({ Key? key }) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final GlobalController c = Get.put(GlobalController());
  List<Product> products = [];
  
  Future<List<Product>> _getProducts() async {
    List<dynamic> productList = [];
    await API_Request.api_query('getProductList', {'SHOP_ID': c.shopID.value}).then((value) {
      productList = value['data'] ?? [];
    });
    return productList.map((dynamic item) {
      return Product.fromJson(item);
    }).toList();
  }
  void _getProductList() async {
    await _getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
  }   
  @override
  void initState() {
    _getProductList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm'),
        actions: [
          IconButton(onPressed: () {
            Get.to(() => AddProductsScreen());
          }, icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getProductList();
        },
        child: FutureBuilder<List<Product>>(
          future: _getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];
                  return ListTile(
                    leading:  Icon(Icons.inventory),
                    title: Text(product.prodName),
                    subtitle: Text(product.prodDescr),
                    trailing: Text('\$${product.prodPrice}'),
                    onTap: () {
                      print(product.prodName);  
                      Get.to(() => ProductDetails(product: product));  
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}