import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/pages/invoices/invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:intl/intl.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final Order order;
  const CreateInvoiceScreen({ Key? key, required this.order }) : super(key: key);

  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final GlobalController c = Get.put(GlobalController());
  late Order order;
  final TextEditingController remark_controller = TextEditingController();
  List<Order> orderItems = [];
  bool isLoading = true;
  final currencyFormatter = NumberFormat.currency(symbol: '\$');
  double totalAmount = 0;
  String newInvoiceNo = '';

  @override
  void initState() {
    super.initState();
    order = widget.order;
    remark_controller.text = '';
    _loadOrderItems();
    newInvoiceNo = _generateInvoiceNo();
    // Remove _calculateTotal() from here
  }

  Future<void> _loadOrderItems() async {
    setState(() => isLoading = true);
    // Fetch order items from server
    await API_Request.api_query('getOrderList', {
      'SHOP_ID': c.shopID.value,  
      'PO_NO': order.poNo
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        orderItems = (value['data'] as List).map((item) => Order.fromJson(item)).toList();
        _calculateTotal(); // Calculate total after loading order items
      }
    });
    setState(() => isLoading = false);
  }

  void _calculateTotal() {
    totalAmount = orderItems.fold(0, (sum, item) => sum + (item.poQty * item.prodPrice));
  }

  Future<bool> _addInvoice(Order item) async {
    return await API_Request.api_query('addNewInvoice', {
      'INVOICE_NO': newInvoiceNo,
      'SHOP_ID': c.shopID.value,
      'PROD_ID': item.prodId.toString(),
      'CUS_ID': item.cusId.toString(),
      'PROD_CODE': item.prodCode,
      'CUST_CD': item.custCd,
      'PO_NO': item.poNo,
      'INVOICE_QTY': item.poQty.toString(),
      'PROD_PRICE': item.prodPrice.toString(),
      'REMARK': remark_controller.text
    }).then((value) => value['tk_status'] == 'OK');
  }

  Future<bool> _createInvoices() async {
    bool allSuccess = true;
    for (var item in orderItems) {
      if (item.poQty > 0) {
        bool success = await _addInvoice(item);
        if (!success) allSuccess = false;
      }
    }
    return allSuccess;
  }

  String _generateInvoiceNo() {
    DateTime now = DateTime.now();
    int shopId = c.shopID.value;
    String random3Number = Random().nextInt(1000).toString().padLeft(3, '0');
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$shopId-$random3Number';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Invoice"),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        color: Colors.grey[100],
        child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSummaryCard(),
                        SizedBox(height: 16),
                        Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderItems.length,
                          itemBuilder: (context, index) {
                            return _buildOrderItemCard(orderItems[index]);
                          },
                        ),
                        _buildTotalSection(),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: remark_controller,
                          decoration: InputDecoration(
                            labelText: 'Remarks',
                            border: OutlineInputBorder(),
                          ),                    
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _validateAndCreateInvoices,
                    child: Text('Create Invoices'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Invoice Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Invoice No: $newInvoiceNo'),  
            Text('Customer: ${order.custCd}'),
            Text('PO Number: ${order.poNo}'),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(Order item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('http://14.160.33.94:3010/product_images/${c.shopID.value}_${item.prodCode}_0.jpg'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.prodName ?? 'Unknown Product', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Code: ${item.prodCode}'),
                  Text('Price: ${currencyFormatter.format(item.prodPrice)}'),
                  Text('Amount: ${currencyFormatter.format(item.poQty * item.prodPrice)}', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: item.poQty.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Qty'),
                onChanged: (value) {
                  setState(() {
                    item.poQty = int.tryParse(value) ?? 0;
                    _calculateTotal();
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  orderItems.remove(item);
                  _calculateTotal();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Card(
      color: Colors.indigo[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(currencyFormatter.format(totalAmount), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _validateAndCreateInvoices() {
    if (orderItems.every((item) => item.poQty == 0)) {
      _showErrorDialog('Please enter a quantity for at least one item.');
      return;
    }

    _createInvoices().then((success) {
      if (success) {
        AwesomeDialog(
          context: context,
          title: 'Success',
          desc: 'Invoices created successfully',
          dialogType: DialogType.success,
          btnOkOnPress: () => Get.off(() => InvoiceScreen()),
        ).show();
      } else {
        _showErrorDialog('Failed to create some invoices. Please try again.');
      }
    });
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      title: 'Error',
      desc: message,
      dialogType: DialogType.error,
      btnOkOnPress: () {},
    ).show();
  }
}
