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
