import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/pages/invoices/edit_invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/pages/invoices/create_invoice_screen.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({ Key? key }) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<Invoice> invoices = [];
  List<Invoice> filteredInvoices = [];
  final GlobalController c = Get.put(GlobalController());
  TextEditingController searchController = TextEditingController();
  
  Future<List<Invoice>> _getInvoices() async {
    List<dynamic> invoiceList = [];
    int shopID = c.shopID.value;
    await API_Request.api_query('getInvoiceList', {'SHOP_ID': shopID}).then((value) {
      invoiceList = value['data'] ?? [];
    });
    return invoiceList.map((dynamic item) {
      return Invoice.fromJson(item);
    }).toList();
  }

  void _getInvoiceList() async {
    await _getInvoices().then((value) {
      setState(() {
        invoices = value;
        filteredInvoices = invoices;
      });
    });
  }

  void _filterInvoices(String query) {
    setState(() {
      filteredInvoices = invoices
          .where((invoice) =>
              GlobalFunction.convertVietnameseString(invoice.prodName ?? '').toLowerCase().contains(GlobalFunction.convertVietnameseString(query).toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getInvoiceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            onPressed: () async {
              final result = await  Get.to(() => CreateInvoiceScreen(order: Order(poId: 0, shopId: 0, prodId: 0, cusId: 0, poNo: '', poQty: 0, prodPrice: 0, remark: '', insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', prodCode: '', custCd: '', cusName: '', prodName: '', deliveredQty: 0, balanceQty: 0)));
              if (true) {
                _getInvoiceList();
              }
            },
            icon: Icon(Icons.add, size: 20),
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search products',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _filterInvoices,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _getInvoiceList();
              },
              child: ListView.builder(
                itemCount: filteredInvoices.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    color: Colors.white,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Container(
                          width: 50,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                filteredInvoices[index].invoiceNo.substring(filteredInvoices[index].invoiceNo.length - 3),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage('http://14.160.33.94:3010/product_images/${c.shopID.value}_${filteredInvoices[index].prodCode}_${0}.jpg'),
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          'Invoice #${filteredInvoices[index].invoiceNo}\nProduct: ${filteredInvoices[index].prodName}\nCustomer: ${filteredInvoices[index].cusName}',
                          style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        subtitle: Text(
                          'Date: ${filteredInvoices[index].insDate.toString().split(' ')[0]}\nQuantity: ${filteredInvoices[index].invoiceQty}\nPrice: \$${filteredInvoices[index].prodPrice.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                        trailing: Text(
                          NumberFormat('\$#,##0.0', 'en_US').format(filteredInvoices[index].invoiceQty * filteredInvoices[index].prodPrice),
                          style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        onTap: () async {
                          final result = await Get.to(() => EditInvoiceScreen(invoice: filteredInvoices[index]));
                          if (true) {
                            _getInvoiceList();
                          }
                        },
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
