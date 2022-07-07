import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';

class AuctionsListingResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<AuctionFileModel>? results;

  AuctionsListingResponseModel(
      {this.count, this.next, this.previous, this.results});

  AuctionsListingResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <AuctionFileModel>[];
      json['results'].forEach((v) {
        results!.add(new AuctionFileModel.fromJson(v));
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
      results = <AuctionFileModel>[];
      json['results'].forEach((v) {
        results!.add(AuctionFileModel.fromJson(v));
      });
    }
    return this;
  }
}

class AuctionFileModel {
  int? id;
  UserModel? userFk;
  String? companyFk;
  String? purpose;
  String? type;
  String? price;
  String? space;
  String? unit;
  String? description;
  String? neighborhood;
  String? currency;
  String? address;
  String? country;
  String? city;
  String? area;
  bool? isSold;
  bool? isActiveListing;

  /*List<Null>? tagFks;*/
  String? updatedAt;
  int? minFiles;
  int? maxFiles;
  bool? isVerified;
  String? createdAt;
  dynamic soldFiles;
  List<Photos> photos = [];

  AuctionFileModel(
      {this.id,
      this.userFk,
      this.companyFk,
      this.purpose,
      this.type,
      this.price,
      this.space,
      this.unit,
      this.description,
      this.neighborhood,
      this.currency,
      this.address,
      this.country,
      this.city,
      this.area,
      this.isSold,
      this.isActiveListing,
      /*   this.tagFks,*/
      this.updatedAt,
      this.minFiles,
      this.maxFiles,
      this.isVerified,
      this.createdAt,
      this.soldFiles,
      this.photos = const []});

  AuctionFileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFk =
        json['user_fk'] != null ? UserModel.fromJson(json['user_fk']) : null;
    companyFk = json['company_fk'];
    purpose = json['purpose'];
    type = json['type'];
    price = json['price'];
    space = json['space'];
    unit = json['unit'];
    description = json['description'];
    neighborhood = json['neighborhood'];
    currency = json['currency'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    area = json['area'];
    isSold = json['is_sold'];
    isActiveListing = json['is_active_listing'];
    /*if (json['tag_fks'] != null) {
      tagFks = <Null>[];
      */ /*json['tag_fks'].forEach((v) {
        tagFks!.add(new Null.fromJson(v));
      });*/ /*
    }*/
    updatedAt = json['updated_at'];
    minFiles = json['min_files'];
    maxFiles = json['max_files'];
    isVerified = json['is_verified'];
    createdAt = json['created_at'];
    soldFiles = json['sold_files'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos.add(Photos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    data['company_fk'] = this.companyFk;
    data['purpose'] = this.purpose;
    data['type'] = this.type;
    data['price'] = this.price;
    data['space'] = this.space;
    data['unit'] = this.unit;
    data['description'] = this.description;
    data['neighborhood'] = this.neighborhood;
    data['currency'] = this.currency;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['area'] = this.area;
    data['is_sold'] = this.isSold;
    data['is_active_listing'] = this.isActiveListing;
    /* if (this.tagFks != null) {
      data['tag_fks'] = this.tagFks!.map((v) => v.toJson()).toList();
    }*/
    data['updated_at'] = this.updatedAt;
    data['min_files'] = this.minFiles;
    data['max_files'] = this.maxFiles;
    data['is_verified'] = this.isVerified;
    data['created_at'] = this.createdAt;
    data['sold_files'] = this.soldFiles;
    data['photos'] = photos.map((v) => v.toJson()).toList();
    return data;
  }
}

class Photos {
  int? id;
  String? filePhoto;
  int? propertyFilesFk;

  Photos({this.id, this.filePhoto, this.propertyFilesFk});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filePhoto = json['file_photo'];
    propertyFilesFk = json['property_files_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_photo'] = this.filePhoto;
    data['property_files_fk'] = this.propertyFilesFk;
    return data;
  }
}
