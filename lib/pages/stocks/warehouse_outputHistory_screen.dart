import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WarehouseOutputHistoryScreen extends StatefulWidget {
  const WarehouseOutputHistoryScreen({Key? key}) : super(key: key);
  @override
  _WarehouseOutputHistoryScreenState createState() =>
      _WarehouseOutputHistoryScreenState();
}
class _WarehouseOutputHistoryScreenState
    extends State<WarehouseOutputHistoryScreen> {
  final GlobalController c = Get.put(GlobalController());
  List<OutputHistory> outputHistory = [];
  Future<List<OutputHistory>> _wareHouseOutputHistory() async {
    List<dynamic> outputHistory = [];
    await API_Request.api_query(
        'getWarehouseOutputHistory', {'SHOP_ID': c.shopID.value}).then((value) {
      outputHistory = value['data'] ?? [];
    });
    return outputHistory.map((dynamic item) {
      return OutputHistory.fromJson(item);
    }).toList();
  }
  void _getOutputHistory() async {
    await _wareHouseOutputHistory().then((value) {
      setState(() {
        outputHistory = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Output History'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _wareHouseOutputHistory();
          setState(() {});
        },
        child: FutureBuilder<List<OutputHistory>>(
          future: _wareHouseOutputHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No output history available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final history = snapshot.data![index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        print('tapped');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'http://14.160.33.94:3010/product_images/${c.shopID.value}_${history.prodCode}_${history.prodImg.split(',')[0]}.jpg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.image_not_supported,
                                      size: 80);
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history.prodName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Quantity: ${history.prodQty}'),
                                  Text(
                                      'Date: ${history.insDate.toString().split(' ')[0]}'),
                                  Text('Customer: ${history.cusName}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
