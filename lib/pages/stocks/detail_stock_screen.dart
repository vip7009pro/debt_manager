import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/stocks/warehouse_outputHistory_screen.dart';
import 'package:debt_manager/pages/stocks/warehouse_output_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailStockScreen extends StatefulWidget {
  const DetailStockScreen({Key? key}) : super(key: key);
  @override
  _DetailStockScreenState createState() => _DetailStockScreenState();
}

class _DetailStockScreenState extends State<DetailStockScreen> {
  final GlobalController c = Get.put(GlobalController());
  List<InputHistory> inputHistory = [];
  List<InputHistory> filteredHistory = [];
  TextEditingController searchController = TextEditingController();

  Future<List<InputHistory>> _wareHouseInputHistory() async {
    List<dynamic> inputHistory = [];
    await API_Request.api_query(
        'getWarehouseInputHistory', {'SHOP_ID': c.shopID.value,'PROD_STATUS': 'Y' }).then((value) {
      inputHistory = value['data'] ?? [];
    });
    return inputHistory.map((dynamic item) {
      return InputHistory.fromJson(item);
    }).toList();
  }

  void _getInputHistory() async {
    await _wareHouseInputHistory().then((value) {
      setState(() {
        inputHistory = value;
        filteredHistory = inputHistory;
      });
    });
  }

  void _filterHistory(String query) {
    setState(() {
      filteredHistory = inputHistory
          .where((history) =>
              GlobalFunction.convertVietnameseString(history.prodName ?? '').contains(GlobalFunction.convertVietnameseString(query)) ||
              GlobalFunction.convertVietnameseString(history.prodCode).contains(GlobalFunction.convertVietnameseString(query)))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getInputHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _filterHistory,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => WarehouseOutputHistoryScreen());
                  },
                  child: Text('Output History'),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _wareHouseInputHistory();
                setState(() {});
              },
              child: ListView.builder(
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  final history = filteredHistory[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        Get.to(()=> WarehouseOutputScreen(product: Product(
                          prodId: history.prodId,
                          prodCode: history.prodCode,
                          prodName: history.prodName ?? '',
                          prodImg: history.prodImg ?? '',
                          shopId: int.parse(c.shopID.value),
                          prodDescr: history.prodDescr ?? '',                          
                          insDate: history.insDate,
                          insUid: history.insUid,
                          updDate: history.updDate,
                          updUid: history.updUid,
                          catId: 0,
                          catCode: '',
                          prodPrice: 0,
                        ), wh_in_id: history.whInId.toString()));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'http://14.160.33.94:3010/product_images/${c.shopID.value}_${history.prodCode}_${history.prodImg?.split(',')[0] ?? ''}.jpg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history.prodName ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.inventory, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 4),
                                      Text(
                                        'Quantity: ${history.stockQty}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 4),
                                      Text(
                                        'Date: ${history.updDate.toString().split(' ')[0]}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 4),
                                      Text(
                                        'Status: ${history.prodStatus}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.business, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 4),
                                      Text(
                                        'Vendor: ${history.vendorName ?? 'N/A'}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 4),
                                      Text(
                                        'Bep: \$${history.bep ?? 'N/A'}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ],
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
