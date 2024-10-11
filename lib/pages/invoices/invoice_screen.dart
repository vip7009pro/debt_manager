import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/pages/invoices/create_invoice_screen.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({ Key? key }) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<Invoice> invoices = [];  
   final GlobalController c = Get.put(GlobalController());
  
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
      });
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
        title: Text('Invoice'),
        actions: [
          IconButton(onPressed: () {
            Get.to(() => CreateInvoiceScreen(order: Order(poId: 0, shopId: 0, prodId: 0, cusId: 0, poNo: '', poQty: 0, prodPrice: 0, remark: '', insDate: DateTime.now(), insUid: '', updDate: DateTime.now(), updUid: '', prodCode: '', custCd: '', cusName: '', prodName: '')));
          }, icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getInvoiceList();
        },
        child: ListView.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Invoice #${invoices[index].invoiceNo}\nProduct: ${invoices[index].prodName}\nCustomer: ${invoices[index].cusName}'),
              subtitle: Text('Date: ${invoices[index].insDate.toString().split(' ')[0]}\nQuantity: ${invoices[index].invoiceQty}\nPrice: \$${invoices[index].prodPrice.toStringAsFixed(2)}'),
              trailing: Text('\$${(invoices[index].invoiceQty * invoices[index].prodPrice).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
              onTap: () {
                // Add logic to view invoice details
              },
            );
          },
        ),
      ),
    );
  }
}