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
  final String catCode;
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
    required this.catCode,
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
      catCode: json['CAT_CODE'],
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
      'CAT_CODE': catCode,
      'PROD_CODE': prodCode,
      'PROD_IMG': prodImg,
    };
  }
}

class Customer {
  final int shopId;
  final num cusId;
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

class Order {
  num poId;
  num shopId;
  num prodId;
  late num cusId;
  String poNo;
  late int poQty;
  late double prodPrice;
  late String remark;
  DateTime insDate;
  String insUid;
  DateTime updDate;
  String updUid;
  String prodCode;
  late String custCd;
  String cusName;
  String prodName;

  Order({
    required this.poId,
    required this.shopId,
    required this.prodId,
    required this.cusId,
    required this.poNo,
    required this.poQty,
    required this.prodPrice,
    required this.remark,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.prodCode,
    required this.custCd,
    required this.cusName,
    required this.prodName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      poId: json['PO_ID'],
      shopId: json['SHOP_ID'],
      prodId: json['PROD_ID'],
      cusId: json['CUS_ID'],
      poNo: json['PO_NO'],
      poQty: json['PO_QTY'],
      prodPrice: json['PROD_PRICE'].toDouble(),
      remark: json['REMARK'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      prodCode: json['PROD_CODE'],
      custCd: json['CUST_CD'],
      cusName: json['CUS_NAME'],
      prodName: json['PROD_NAME'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PO_ID': poId,
      'SHOP_ID': shopId,
      'PROD_ID': prodId,
      'CUS_ID': cusId,
      'PO_NO': poNo,
      'PO_QTY': poQty,
      'PROD_PRICE': prodPrice,
      'REMARK': remark,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'PROD_CODE': prodCode,
      'CUST_CD': custCd,
      'CUS_NAME': cusName,
      'PROD_NAME': prodName,
    };
  }
}

class Invoice {
  final int invoiceId;
  final String invoiceNo;
  final int shopId;
  final int prodId;
  final int cusId;
  final String prodCode;
  final String custCd;
  final String poNo;
  final int invoiceQty;
  final double prodPrice;
  final String remark;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  final String cusName;
  final String? prodName;

  Invoice({
    required this.invoiceId,
    required this.invoiceNo,
    required this.shopId,
    required this.prodId,
    required this.cusId,
    required this.prodCode,
    required this.custCd,
    required this.poNo,
    required this.invoiceQty,
    required this.prodPrice,
    required this.remark,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.cusName,
    required this.prodName,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceId: json['INVOICE_ID'],
      invoiceNo: json['INVOICE_NO'],
      shopId: json['SHOP_ID'],
      prodId: json['PROD_ID'],
      cusId: json['CUS_ID'],
      prodCode: json['PROD_CODE'],
      custCd: json['CUST_CD'],
      poNo: json['PO_NO'],
      invoiceQty: json['INVOICE_QTY'],
      prodPrice: json['PROD_PRICE'].toDouble(),
      remark: json['REMARK'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      cusName: json['CUS_NAME'],
      prodName: json['PROD_NAME'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'INVOICE_ID': invoiceId,
      'INVOICE_NO': invoiceNo,
      'SHOP_ID': shopId,
      'PROD_ID': prodId,
      'CUS_ID': cusId,
      'PROD_CODE': prodCode,
      'CUST_CD': custCd,
      'PO_NO': poNo,
      'INVOICE_QTY': invoiceQty,
      'PROD_PRICE': prodPrice,
      'REMARK': remark,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'CUS_NAME': cusName,
      'PROD_NAME': prodName,
    };
  }
}

class InputHistory {
  final int shopId;
  final int whInId;
  final int prodId;
  final int prodQty;
  final String prodStatus;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  final String prodCode;
  final String? custCd;
  final String? vendorCode;
  final String? prodName;
  final String? prodDescr;
  final String? prodImg;
  final String? vendorName;
  final double? bep;
  final int? stockQty;
  InputHistory({
    required this.shopId,
    required this.whInId,
    required this.prodId,
    required this.prodQty,
    required this.prodStatus,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.prodCode,
    required this.custCd,
    required this.vendorCode,
    required this.prodName,
    required this.prodDescr,
    required this.prodImg,
    required this.vendorName,
    required this.bep,
    required this.stockQty,
  });

  factory InputHistory.fromJson(Map<String, dynamic> json) {
    return InputHistory(
      shopId: json['SHOP_ID'],
      whInId: json['WH_IN_ID'],
      prodId: json['PROD_ID'],
      prodQty: json['PROD_QTY'],
      prodStatus: json['PROD_STATUS'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      prodCode: json['PROD_CODE'],
      custCd: json['CUST_CD'],
      vendorCode: json['VENDOR_CODE'],
      prodName: json['PROD_NAME'],
      prodDescr: json['PROD_DESCR'],
      prodImg: json['PROD_IMG'],
      vendorName: json['VENDOR_NAME'],
      bep: json['BEP'].toDouble(),
      stockQty: json['STOCK_QTY'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SHOP_ID': shopId,
      'WH_IN_ID': whInId,
      'PROD_ID': prodId,
      'PROD_QTY': prodQty,
      'PROD_STATUS': prodStatus,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'PROD_CODE': prodCode,
      'CUST_CD': custCd,
      'VENDOR_CODE': vendorCode,
      'PROD_NAME': prodName,
      'PROD_DESCR': prodDescr,
      'PROD_IMG': prodImg,
      'VENDOR_NAME': vendorName,
      'BEP': bep,
      'STOCK_QTY': stockQty,
    };
  }
}

class OutputHistory {
  final int shopId;
  final int whOutId;
  final int prodId;
  final int prodQty;
  final int cusId;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  final String prodCode;
  final String custCd;
  final String prodName;
  final String prodDescr;
  final String prodImg;
  final String cusName;

  OutputHistory({
    required this.shopId,
    required this.whOutId,
    required this.prodId,
    required this.prodQty,
    required this.cusId,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.prodCode,
    required this.custCd,
    required this.prodName,
    required this.prodDescr,
    required this.prodImg,
    required this.cusName,
  });

  factory OutputHistory.fromJson(Map<String, dynamic> json) {
    return OutputHistory(
      shopId: json['SHOP_ID'],
      whOutId: json['WH_OUT_ID'],
      prodId: json['PROD_ID'],
      prodQty: json['PROD_QTY'],
      cusId: json['CUS_ID'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      prodCode: json['PROD_CODE'],
      custCd: json['CUST_CD'],
      prodName: json['PROD_NAME'],
      prodDescr: json['PROD_DESCR'],
      prodImg: json['PROD_IMG'],
      cusName: json['CUS_NAME'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SHOP_ID': shopId,
      'WH_OUT_ID': whOutId,
      'PROD_ID': prodId,
      'PROD_QTY': prodQty,
      'CUS_ID': cusId,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'PROD_CODE': prodCode,
      'CUST_CD': custCd,
      'PROD_NAME': prodName,
      'PROD_DESCR': prodDescr,
      'PROD_IMG': prodImg,
      'CUS_NAME': cusName,
    };
  }
}

class Stock {
  final int prodId;
  final String prodCode;
  final String prodName;
  final double prodPrice;
  final String prodImg;
  final String prodDescr;
  final int catId;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  final int inputQty;
  final int outputQty;
  final int stockQty;

  Stock({
    required this.prodId,
    required this.prodCode,
    required this.prodName,
    required this.prodPrice,
    required this.prodImg,
    required this.prodDescr,
    required this.catId,
    required this.insDate,
    required this.updDate,
    required this.insUid,
    required this.updUid,
    required this.inputQty,
    required this.outputQty,
    required this.stockQty,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      prodId: json['PROD_ID'],
      prodCode: json['PROD_CODE'],
      prodName: json['PROD_NAME'],
      prodPrice: json['PROD_PRICE'].toDouble(),
      prodImg: json['PROD_IMG'],
      prodDescr: json['PROD_DESCR'],
      catId: json['CAT_ID'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      inputQty: json['INPUT_QTY'],
      outputQty: json['OUTPUT_QTY'],
      stockQty: json['STOCK_QTY'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PROD_ID': prodId,
      'PROD_CODE': prodCode,
      'PROD_NAME': prodName,
      'PROD_PRICE': prodPrice,
      'PROD_IMG': prodImg,
      'PROD_DESCR': prodDescr,
      'CAT_ID': catId,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'INPUT_QTY': inputQty,
      'OUTPUT_QTY': outputQty,
      'STOCK_QTY': stockQty,
    };
  }
}

class Category {
  final int catId;
  final String catName;
  final DateTime insDate;
  final String insUid;
  final DateTime updDate;
  final String updUid;
  final int shopId;
  final String catCode;

  Category({
    required this.catId,
    required this.catName,
    required this.insDate,
    required this.insUid,
    required this.updDate,
    required this.updUid,
    required this.shopId,
    required this.catCode,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catId: json['CAT_ID'],
      catName: json['CAT_NAME'],
      insDate: DateTime.parse(json['INS_DATE']),
      insUid: json['INS_UID'],
      updDate: DateTime.parse(json['UPD_DATE']),
      updUid: json['UPD_UID'],
      shopId: json['SHOP_ID'],
      catCode: json['CAT_CODE'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CAT_ID': catId,
      'CAT_NAME': catName,
      'INS_DATE': insDate.toIso8601String(),
      'INS_UID': insUid,
      'UPD_DATE': updDate.toIso8601String(),
      'UPD_UID': updUid,
      'SHOP_ID': shopId,
      'CAT_CODE': catCode,
    };
  }
}
