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
        title: Text('Sản phẩm', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 104, 160, 245),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddProductsScreen());
            },
            icon: Icon(Icons.add, color: Colors.white)
          )
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
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products found', style: TextStyle(color: Colors.grey)));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          'http://14.160.33.94:3010/product_images/${product.shopId}_${product.prodCode}_0.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.inventory, color: const Color.fromARGB(255, 110, 109, 106), size: 50);
                          },
                        ),
                      ),
                      title: Text(product.prodName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      subtitle: Text(product.prodDescr, style: TextStyle(color: Colors.green)),
                      trailing: Text('\$${product.prodPrice}', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      onTap: () {
                        print(product.prodName);  
                        Get.to(() => ProductDetails(product: product));  
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      backgroundColor: Colors.yellow[50],
    );
  }
}