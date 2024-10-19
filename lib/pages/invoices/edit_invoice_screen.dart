import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';

class EditInvoiceScreen extends StatefulWidget {
  final Invoice invoice;

  const EditInvoiceScreen({Key? key, required this.invoice}) : super(key: key);

  @override
  _EditInvoiceScreenState createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  final GlobalController c = Get.find<GlobalController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _productNameController;
  late TextEditingController _customerNameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;
  late TextEditingController _remarkController;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(text: widget.invoice.prodName);
    _customerNameController = TextEditingController(text: widget.invoice.cusName);
    _quantityController = TextEditingController(text: widget.invoice.invoiceQty.toString());
    _priceController = TextEditingController(text: widget.invoice.prodPrice.toString());
    _dateController = TextEditingController(text: widget.invoice.insDate.toString().split(' ')[0]);
    _remarkController = TextEditingController(text: widget.invoice.remark);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _customerNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _updateInvoice() async {
    if (_formKey.currentState!.validate()) {
      try {
        await API_Request.api_query('updateInvoice', {
          'INVOICE_NO': widget.invoice.invoiceNo,
          'SHOP_ID': c.shopID.value,
          'PROD_NAME': _productNameController.text,
          'CUS_NAME': _customerNameController.text,
          'INVOICE_QTY': int.parse(_quantityController.text),
          'PROD_PRICE': double.parse(_priceController.text),
          'INS_DATE': _dateController.text,
          'REMARK': _remarkController.text,
        });
        Get.back(result: true);
        Get.snackbar('Success', 'Invoice updated successfully',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Error', 'Failed to update invoice: $e',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> _deleteInvoice() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this invoice?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Get.back(result: false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await API_Request.api_query('deleteInvoice', {
          'INVOICE_NO': widget.invoice.invoiceNo,
          'SHOP_ID': c.shopID.value,
        });
        Get.back(result: true);
        Get.snackbar('Success', 'Invoice deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete invoice: $e',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Invoice', style: TextStyle(fontSize: 16)),
        backgroundColor: const Color.fromARGB(255, 175, 162, 46),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: _deleteInvoice,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Invoice #${widget.invoice.invoiceNo}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter product name' : null,
                ),
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter customer name' : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter quantity' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter price' : null,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(_dateController.text),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text = pickedDate.toString().split(' ')[0];
                      });
                    }
                  },
                ),
                TextFormField(
                  controller: _remarkController,
                  decoration: InputDecoration(labelText: 'Remark'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter remark' : null,
                ),  
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateInvoice,
                  child: Text('Update Invoice'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 175, 162, 46),
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
