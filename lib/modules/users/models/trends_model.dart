import 'package:zeerac_flutter/dio_networking/decodable.dart';

class TrendsModel implements Decodeable {
  String? area;
  String? type;
  int? propertyCount;

  TrendsModel({this.area, this.type, this.propertyCount});

  TrendsModel.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    type = json['type'];
    propertyCount = json['property_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['type'] = this.type;
    data['property_count'] = this.propertyCount;
    return data;
  }

  @override
  decode(json) {
    area = json['area'];
    type = json['type'];
    propertyCount = json['property_count'];
    return this;
  }
}
