import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
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
    await API_Request.api_query('getInvoiceList', {'SHOP_ID': c.shopID.value}).then((value) {
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
              GlobalFunction.convertVietnameseString(invoice.prodName).toLowerCase().contains(GlobalFunction.convertVietnameseString(query).toLowerCase()))
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
        backgroundColor: const Color.fromARGB(255, 175, 162, 46),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => CreateInvoiceScreen(order: Order(poId: 0, shopId: 0, prodId: 0, cusId: 0, poNo: '', poQty: 0, prodPrice: 0, remark: '', insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', prodCode: '', custCd: '', cusName: '', prodName: '')));
            },
            icon: Icon(Icons.add, size: 20),
            color: Colors.yellow,
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
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    color: index % 2 == 0 ? Colors.blue[100] : Colors.green[100],
                    child: ListTile(
                      leading: Icon(Icons.receipt, color: Colors.orange, size: 20),
                      title: Text(
                        'Invoice #${filteredInvoices[index].invoiceNo}\nProduct: ${filteredInvoices[index].prodName}\nCustomer: ${filteredInvoices[index].cusName}',
                        style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      subtitle: Text(
                        'Date: ${filteredInvoices[index].insDate.toString().split(' ')[0]}\nQuantity: ${filteredInvoices[index].invoiceQty}\nPrice: \$${filteredInvoices[index].prodPrice.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 11),
                      ),
                      trailing: Text(
                        NumberFormat('\$#,##0.0', 'en_US').format(filteredInvoices[index].invoiceQty * filteredInvoices[index].prodPrice),
                        style: TextStyle(color: const Color.fromARGB(255, 6, 141, 29), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      onTap: () {
                        // Add logic to view invoice details
                      },
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