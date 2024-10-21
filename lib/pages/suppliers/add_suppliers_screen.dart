import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:flutter/material.dart';
import 'package:debt_manager/controller/APIRequest.dart';
import 'package:get/get.dart'; 
import 'package:flutter_contacts/flutter_contacts.dart';

class AddSuppliersScreen extends StatefulWidget {
  const AddSuppliersScreen({ Key? key }) : super(key: key);

  @override
  _AddSuppliersScreenState createState() => _AddSuppliersScreenState();
}

class _AddSuppliersScreenState extends State<AddSuppliersScreen> {
  final TextEditingController _supplierCodeController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _supplierAddressController = TextEditingController();
  final TextEditingController _supplierPhoneController = TextEditingController();
  final GlobalController c = Get.put(GlobalController());

  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  Contact? _selectedContact;

  bool _showContactList = false;
  bool _isContactsLoaded = false;

  Future<bool> _addSupplier(String VENDOR_CODE, String VENDOR_NAME, String VENDOR_ADD, String VENDOR_PHONE) async {
    bool check = true;
    String shopID = c.shopID.value;
    await API_Request.api_query('addvendor', {      
      'SHOP_ID': shopID,
      'VENDOR_CODE': VENDOR_CODE,
      'VENDOR_NAME': VENDOR_NAME,
      'VENDOR_ADD': VENDOR_ADD,
      'VENDOR_PHONE': VENDOR_PHONE
    }).then((value) {
      check = value['tk_status'] == 'OK';
    });
    return check;    
  }

  String _generateSupplierCode() {
    return '${String.fromCharCodes(List.generate(4, (index) => Random().nextInt(26) + 65))}${Random().nextInt(10000).toString().padLeft(4, '0')}';
  } 

  @override
  void initState() {
    super.initState();
    _supplierCodeController.text = _generateSupplierCode();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final allContacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = allContacts.where((contact) => contact.phones.isNotEmpty).toList();
        _filteredContacts = _contacts;
        _isContactsLoaded = true;
      });
    }
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
              contact.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _selectedContact = null;
      _showContactList = query.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _supplierCodeController.dispose();
    _supplierNameController.dispose();
    _supplierAddressController.dispose();
    _supplierPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhà cung cấp'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _supplierCodeController,
                          decoration: InputDecoration(
                            labelText: 'Mã nhà cung cấp',
                            hintText: 'Nhập mã nhà cung cấp',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.code),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _supplierNameController,
                          decoration: InputDecoration(
                            labelText: 'Tên nhà cung cấp',
                            hintText: _isContactsLoaded 
                              ? 'Nhập tên nhà cung cấp' 
                              : 'Đang tải danh bạ...',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            suffixIcon: _isContactsLoaded 
                              ? null 
                              : SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                          ),
                          onChanged: (value) {
                            if (_isContactsLoaded) {
                              _filterContacts(value);
                              setState(() {});
                            }
                          },
                          enabled: _isContactsLoaded,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_showContactList && _isContactsLoaded)
                  Card(
                    elevation: 2,
                    child: Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _filteredContacts[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(contact.displayName[0]),
                            ),
                            title: Text(contact.displayName),
                            subtitle: Text(contact.phones.first.number),
                            onTap: () {
                              setState(() {
                                _selectedContact = contact;
                                _supplierNameController.text = contact.displayName;
                                _supplierPhoneController.text = contact.phones.first.number;
                                _showContactList = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _supplierAddressController,
                          decoration: InputDecoration(
                            labelText: 'Địa chỉ nhà cung cấp',
                            hintText: 'Nhập địa chỉ nhà cung cấp',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _supplierPhoneController,
                          decoration: InputDecoration(
                            labelText: 'Số điện thoại nhà cung cấp',
                            hintText: 'Nhập số điện thoại nhà cung cấp',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    bool check = await _addSupplier(
                      _supplierCodeController.text,
                      _supplierNameController.text,
                      _supplierAddressController.text,
                      _supplierPhoneController.text
                    );  
                    if (check) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        title: 'Thêm nhà cung cấp thành công',
                        btnOkOnPress: () {
                          Get.back();
                        },
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        title: 'Thêm nhà cung cấp thất bại',
                        desc: 'Vui lòng kiểm tra lại thông tin nhà cung cấp',
                        btnOkOnPress: () {},
                      ).show();
                    } 
                  },
                  child: const Text('Lưu nhà cung cấp'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
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
