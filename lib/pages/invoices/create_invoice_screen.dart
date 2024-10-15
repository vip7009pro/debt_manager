import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final Order order;
  const CreateInvoiceScreen({ Key? key, required this.order }) : super(key: key);

  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final GlobalController c = Get.put(GlobalController());
  late Order order;
  final TextEditingController prod_id_controller = TextEditingController();
  final TextEditingController cus_id_controller = TextEditingController();
  final TextEditingController po_no_controller = TextEditingController();
  final TextEditingController invoice_qty_controller = TextEditingController();
  final TextEditingController remark_controller = TextEditingController();
  final TextEditingController invoice_no_controller = TextEditingController();

  Future<bool> _addInvoice(String invoiceNo, String shopId, String prodId, String cusId, String prodCode, String custCd, String poNo, String invoiceQty, String prodPrice, String remark) async {
    // Add invoice logic here
    bool check = true;
    await API_Request.api_query('addNewInvoice', {
      'INVOICE_NO': invoiceNo,
      'SHOP_ID': shopId,
      'PROD_ID': prodId,
      'CUS_ID': cusId,
      'PROD_CODE': prodCode,
      'CUST_CD': custCd,
      'PO_NO': poNo,
      'INVOICE_QTY': invoiceQty,
      'PROD_PRICE': prodPrice,
      'REMARK': remark
    }).then((value) {
      if (value['tk_status'] == 'OK') {
        check = true;        
      } else {
        check = false;
      }
    });
    return check;    
  }

 //generate invoice no with current date and time and shop id and random 3 number
 String _generateInvoiceNo() {
  DateTime now = DateTime.now();
  String shopId = c.shopID.value;
  String random3Number = Random().nextInt(1000).toString().padLeft(3, '0');
  String invoiceNumber = '${now.year}${now.month}${now.day}-$shopId-$random3Number';
  return invoiceNumber;
 }  

  @override
  void initState() {
    super.initState();
    order = widget.order; 
    prod_id_controller.text = order.prodId.toString();
    cus_id_controller.text = order.cusId.toString();
    po_no_controller.text = order.poNo;
    invoice_qty_controller.text = '0';
    remark_controller.text = '';  
    invoice_no_controller.text = _generateInvoiceNo();  
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Invoice"),
        backgroundColor: const Color.fromARGB(255, 87, 214, 236),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[100]!, Colors.purple[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                //invoice no
                TextFormField(
                  controller: invoice_no_controller,
                  decoration: InputDecoration(
                    labelText: 'INVOICE_NO',
                    hintText: 'Enter Invoice Number',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),  
                SizedBox(height: 16),
                TextFormField(
                  controller: prod_id_controller,
                  decoration: InputDecoration(
                    labelText: 'PROD_ID',
                    hintText: 'Enter Product ID',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: cus_id_controller,
                  decoration: InputDecoration(
                    labelText: 'CUS_ID',
                    hintText: 'Enter Customer ID',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: po_no_controller,
                  decoration: InputDecoration(
                    labelText: 'PO_NO',
                    hintText: 'Enter Purchase Order Number',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: invoice_qty_controller,
                  decoration: InputDecoration(
                    labelText: 'INVOICE_QTY',
                    hintText: 'Enter Invoice Quantity',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: remark_controller,
                  decoration: InputDecoration(
                    labelText: 'REMARK',
                    hintText: 'Enter Remark',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to save the new invoice
                    _addInvoice(invoice_no_controller.text, c.shopID.value, prod_id_controller.text, cus_id_controller.text, order.prodCode, order.custCd, po_no_controller.text, invoice_qty_controller.text, order.prodPrice.toString(), remark_controller.text).then((value) {
                      if (value) {
                        AwesomeDialog(
                          context: context,
                          title: 'Success',
                          body: Text('Invoice created successfully'),
                          dialogType: DialogType.success,
                          btnOkOnPress: () {
                            Get.back();
                          },
                        ).show(); 
                      } else {
                        AwesomeDialog(
                          context: context,
                          title: 'Error',
                          body: Text('Failed to create invoice'),
                          dialogType: DialogType.error,
                          btnOkOnPress: () {
                            //Get.back();
                          },
                        ).show(); 
                      } 
                      }); 
                  },
                  child: const Text('Create Invoice', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}