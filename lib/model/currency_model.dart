import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyModel {
  Timestamp? createdAt;
  String? symbol;
  String? code;
  bool? enable;
  bool? symbolAtRight;
  String? name;
  int? decimalDigits;
  String? id;
  Timestamp? updatedAt;

  CurrencyModel({
    this.createdAt,
    this.symbol,
    this.code,
    this.enable,
    this.symbolAtRight,
    this.name,
    this.decimalDigits,
    this.id,
    this.updatedAt,
  });

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] != null
        ? (json['createdAt'] is Timestamp
        ? json['createdAt']
        : Timestamp(json['createdAt']['_seconds'], json['createdAt']['_nanoseconds']))
        : null;
    symbol = json['symbol'];
    code = json['code'];
    enable = json['enable'];
    symbolAtRight = json['symbolAtRight'];
    name = json['name'];
    decimalDigits = json['decimalDigits'] != null ? int.parse(json['decimalDigits'].toString()) : 2;
    id = json['id'];
    updatedAt = json['updatedAt'] != null
        ? (json['updatedAt'] is Timestamp
        ? json['updatedAt']
        : Timestamp(json['updatedAt']['_seconds'], json['updatedAt']['_nanoseconds']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['symbol'] = symbol;
    data['code'] = code;
    data['enable'] = enable;
    data['symbolAtRight'] = symbolAtRight;
    data['name'] = name;
    data['decimalDigits'] = decimalDigits;
    data['id'] = id;
    data['updatedAt'] = updatedAt;
    return data;
  }
}