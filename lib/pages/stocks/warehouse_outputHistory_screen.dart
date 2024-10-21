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
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Future<List<OutputHistory>> _wareHouseOutputHistory() async {
    List<dynamic> outputHistory = [];
    await API_Request.api_query(
        'getWarehouseOutputHistory', {'SHOP_ID': c.shopID.value}).then((value) {
      outputHistory = value['data'] ?? [];
    });

    return outputHistory
        .where((element) => element['PROD_NAME']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .map((dynamic item) {
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
  void initState() {
    super.initState();
    _getOutputHistory();
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),
            ),
            Expanded(
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
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'http://14.160.33.94:3010/product_images/${c.shopID.value}_${history.prodCode}_${history.prodImg.split(',')[0]}.jpg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[600]),
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
                                          history.prodName,
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
                                            Icon(Icons.shopping_cart, size: 16, color: Colors.green),
                                            SizedBox(width: 4),
                                            Text(
                                              'Quantity: ${history.prodQty}',
                                              style: TextStyle(fontSize: 14, color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                            SizedBox(width: 4),
                                            Text(
                                              'Date: ${history.insDate.toString().split(' ')[0]}',
                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.person, size: 16, color: Colors.blue),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'Customer: ${history.cusName}',
                                                style: TextStyle(fontSize: 14, color: Colors.blue),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
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


