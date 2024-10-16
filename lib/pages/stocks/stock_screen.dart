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
      child: ListView.builder(
        itemCount: 10, // Replace with actual product count
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () {
                // Add logic to view product stock details
                Get.to(() => ProductDetails(
                    product: Product(
                        prodId: 0,
                        shopId: 0,
                        prodName: '',
                        prodDescr: '',
                        prodPrice: 0,
                        insDate: DateTime.now(),
                        insUid: '',
                        updDate: DateTime.now(),
                        updUid: '',
                        catId: 0,
                        prodCode: '',
                        prodImg: '')));
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(Icons.inventory, color: Colors.indigo, size: 25),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product ${index + 1}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade800),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Description of Product ${index + 1}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Stock: ${(index + 1) * 5}',
                        style: TextStyle(
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
    );
  }
}
