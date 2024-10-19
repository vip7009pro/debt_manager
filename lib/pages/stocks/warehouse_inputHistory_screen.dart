import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseInputHistoryScreen extends StatefulWidget {
  const WarehouseInputHistoryScreen({Key? key}) : super(key: key);

  @override
  _WarehouseInputHistoryScreenState createState() =>
      _WarehouseInputHistoryScreenState();
}

class _WarehouseInputHistoryScreenState
    extends State<WarehouseInputHistoryScreen> {
  final GlobalController c = Get.put(GlobalController());
  List<InputHistory> inputHistory = [];
  List<InputHistory> filteredHistory = [];
  final TextEditingController _searchController = TextEditingController();

  Future<List<InputHistory>> _wareHouseInputHistory() async {
    List<dynamic> inputHistory = [];
    await API_Request.api_query(
        'getWarehouseInputHistory', {'SHOP_ID': c.shopID.value}).then((value) {
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
          .where((element) =>
              element.prodName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
@override
  initState() {
    super.initState();
    _getInputHistory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input History'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _wareHouseInputHistory();
          setState(() {});
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterHistory,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<InputHistory>>(
                future: _wareHouseInputHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No input history available'));
                  } else {
                    return ListView.builder(
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final history = filteredHistory[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                                      'http://14.160.33.94:3010/product_images/${c.shopID.value}_${history.prodCode}_${history.prodImg?.split(',')[0] ?? ''}.jpg',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported, size: 80);
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
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text('Quantity: ${history.prodQty} / Date: ${history.insDate.toString().split(' ')[0]}'),
                                        Text('Status: ${history.prodStatus} / Vendor: ${history.vendorName ?? 'N/A'}'),
                                        Text('Bep: \$${history.bep ?? 'N/A'}'),
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
          ],
        ),
      ),
    );
  }
}

