import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../products/product_details.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);
  @override
  _StockScreenState createState() => _StockScreenState();
}
class _StockScreenState extends State<StockScreen> {
  final GlobalController c = Get.put(GlobalController());
  List<Stock> stocks = [];
  List<Stock> filteredStocks = [];
  TextEditingController searchController = TextEditingController();
  Future<List<Stock>> _getProductStocks() async {
    List<dynamic> stocks = [];
    await API_Request.api_query('getProductStock', {'SHOP_ID': c.shopID.value})
        .then((value) {
      stocks = value['data'] ?? [];
    });
    return stocks.map((dynamic item) {
      return Stock.fromJson(item);
    }).toList();
  }
  void _getStock() async {
    await _getProductStocks().then((value) {
      setState(() {
        stocks = value;
        filteredStocks = stocks;
      });
    });
  }
  void _filterStocks(String query) {
    setState(() {
      filteredStocks = stocks
          .where((stock) =>
              GlobalFunction.convertVietnameseString(stock.prodName)
                  .toLowerCase()
                  .contains(GlobalFunction.convertVietnameseString(query)
                      .toLowerCase()) ||
              GlobalFunction.convertVietnameseString(stock.prodDescr)
                  .toLowerCase()
                  .contains(GlobalFunction.convertVietnameseString(query)
                      .toLowerCase()))
          .toList();
    });
  }
  @override
  void initState() {
    super.initState();
    _getStock();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.indigo, Colors.indigo.shade200],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterStocks,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _getStock();
                setState(() {});
              },
              child: ListView.builder(
                itemCount: filteredStocks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {
                        // Add logic to view product stock details
                        Get.to(() => ProductDetails(
                            product: Product(
                                prodId: stocks[index].prodId,
                                shopId: c.shopID.value,
                                prodName: stocks[index].prodName,
                                prodDescr: stocks[index].prodDescr,
                                prodPrice: stocks[index].prodPrice,
                                insDate: stocks[index].insDate,
                                insUid: stocks[index].insUid,
                                updDate: stocks[index].updDate,
                                updUid: stocks[index].updUid,
                                catId: stocks[index].catId,
                                catCode: '', 
                                prodCode: stocks[index].prodCode,
                                prodImg: stocks[index].prodImg)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                'http://14.160.33.94:3010/product_images/${c.shopID.value}_${filteredStocks[index].prodCode}_${filteredStocks[index].prodImg.split(',')[0]}.jpg',
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.image_not_supported,
                                      size: 50, color: Colors.indigo.shade300);
                                },
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredStocks[index].prodName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.indigo.shade800),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    filteredStocks[index].prodDescr,
                                    style:  TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                'Stock: ${filteredStocks[index].stockQty}',
                                style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
