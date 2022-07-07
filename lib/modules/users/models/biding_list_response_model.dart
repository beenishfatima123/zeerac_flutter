import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';

class BidingListResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<BidModel>? results;

  BidingListResponseModel({this.count, this.next, this.previous, this.results});

  BidingListResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <BidModel>[];
      json['results'].forEach((v) {
        results!.add(new BidModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <BidModel>[];
      json['results'].forEach((v) {
        results!.add(new BidModel.fromJson(v));
      });
    }
    return this;
  }
}

class BidModel {
  int? id;
  String? price;
  int? startingRange;
  int? endingRange;
  bool? isClosed;
  String? createdAt;
  String? updatedAt;
  UserModel? userFk;
  int? propertyFilesFk;

  BidModel(
      {this.id,
      this.price,
      this.startingRange,
      this.endingRange,
      this.isClosed,
      this.createdAt,
      this.updatedAt,
      this.userFk,
      this.propertyFilesFk});

  BidModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    startingRange = json['starting_range'];
    endingRange = json['ending_range'];
    isClosed = json['is_closed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userFk = json['user_fk'] != null
        ? new UserModel.fromJson(json['user_fk'])
        : null;
    propertyFilesFk = json['property_files_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['starting_range'] = this.startingRange;
    data['ending_range'] = this.endingRange;
    data['is_closed'] = this.isClosed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    data['property_files_fk'] = this.propertyFilesFk;
    return data;
  }
}
