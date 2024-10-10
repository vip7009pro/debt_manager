class Shop {
  final num shopId;
  final String uid;
  late final String shopName;
  late final String shopDescr;
  late final String shopAdd;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  late final String shopAvatar;

  Shop({
    required this.shopId,
    required this.uid,
    required this.shopName,
    required this.shopDescr,
    required this.shopAdd,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.shopAvatar,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shopId: json['SHOP_ID'],
      uid: json['UID'],
      shopName: json['SHOP_NAME'],
      shopDescr: json['SHOP_DESCR'],
      shopAdd: json['SHOP_ADD'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      shopAvatar: json['SHOP_AVATAR'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SHOP_ID': shopId,
      'UID': uid,
      'SHOP_NAME': shopName,
      'SHOP_DESCR': shopDescr,
      'SHOP_ADD': shopAdd,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'SHOP_AVATAR': shopAvatar,
    };
  }
}



class Vendor {
  final num shopId;
  final String vendorCode;
  final String vendorName;
  final String vendorAdd;
  final String vendorPhone;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;

  Vendor({
    required this.shopId,
    required this.vendorCode,
    required this.vendorName,
    required this.vendorAdd,
    required this.vendorPhone,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      shopId: json['SHOP_ID'],
      vendorCode: json['VENDOR_CODE'],
      vendorName: json['VENDOR_NAME'],
      vendorAdd: json['VENDOR_ADD'],
      vendorPhone: json['VENDOR_PHONE'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SHOP_ID': shopId,
      'VENDOR_CODE': vendorCode,
      'VENDOR_NAME': vendorName,
      'VENDOR_ADD': vendorAdd,
      'VENDOR_PHONE': vendorPhone,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
    };
  }
}
class Product {
  final int prodId;
  final int shopId;
  final String prodName;
  final String prodDescr;
  final double prodPrice;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  final int catId;
  final String prodCode;
  final String prodImg;

  Product({
    required this.prodId,
    required this.shopId,
    required this.prodName,
    required this.prodDescr,
    required this.prodPrice,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.catId,
    required this.prodCode,
    required this.prodImg,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      prodId: json['PROD_ID'],
      shopId: json['SHOP_ID'],
      prodName: json['PROD_NAME'],
      prodDescr: json['PROD_DESCR'],
      prodPrice: json['PROD_PRICE'].toDouble(),
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      catId: json['CAT_ID'],
      prodCode: json['PROD_CODE'],
      prodImg: json['PROD_IMG'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PROD_ID': prodId,
      'SHOP_ID': shopId,
      'PROD_NAME': prodName,
      'PROD_DESCR': prodDescr,
      'PROD_PRICE': prodPrice,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'CAT_ID': catId,
      'PROD_CODE': prodCode,
      'PROD_IMG': prodImg,
    };
  }
}

class Customer {
  final String shopId;
  final String cusId;
  final String cusName;
  final String cusPhone;
  final String cusEmail;
  final String cusAdd;
  final String cusLoc;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  final String custCd;

  Customer({
    required this.shopId,
    required this.cusId,
    required this.cusName,
    required this.cusPhone,
    required this.cusEmail,
    required this.cusAdd,
    required this.cusLoc,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.custCd,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      shopId: json['SHOP_ID'],
      cusId: json['CUS_ID'],
      cusName: json['CUS_NAME'],
      cusPhone: json['CUS_PHONE'],
      cusEmail: json['CUS_EMAIL'],
      cusAdd: json['CUS_ADD'],
      cusLoc: json['CUS_LOC'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      custCd: json['CUST_CD'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SHOP_ID': shopId,
      'CUS_ID': cusId,
      'CUS_NAME': cusName,
      'CUS_PHONE': cusPhone,
      'CUS_EMAIL': cusEmail,
      'CUS_ADD': cusAdd,
      'CUS_LOC': cusLoc,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'CUST_CD': custCd,
    };
  }
}
