import 'package:zeerac_flutter/dio_networking/decodable.dart';

class UserPreferencePostModel implements Decodeable {
  int? priceMin;
  int? priceMax;
  int? yearBuild;
  String? spaceMin;
  String? unit;
  bool? newlyConstructed;
  List<TagFks>? tagFks;
  String? spaceMax;
  String? area;
  String? city;
  String? country;
  String? createdAt;
  String? updatedAt;
  int? id;
  UserFk? userFk;

  UserPreferencePostModel(
      {this.priceMin,
      this.priceMax,
      this.yearBuild,
      this.spaceMin,
      this.unit,
      this.newlyConstructed,
      this.tagFks,
      this.spaceMax,
      this.area,
      this.city,
      this.country,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.userFk});

  UserPreferencePostModel.fromJson(Map<String, dynamic> json) {
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    yearBuild = json['year_build'];
    spaceMin = json['space_min'];
    unit = json['unit'];
    newlyConstructed = json['newly_constructed'];
    if (json['tag_fks'] != null) {
      tagFks = <TagFks>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(new TagFks.fromJson(v));
      });
    }
    spaceMax = json['space_max'];
    area = json['area'];
    city = json['city'];
    country = json['country'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
    userFk =
        json['user_fk'] != null ? new UserFk.fromJson(json['user_fk']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_min'] = this.priceMin;
    data['price_max'] = this.priceMax;
    data['year_build'] = this.yearBuild;
    data['space_min'] = this.spaceMin;
    data['unit'] = this.unit;
    data['newly_constructed'] = this.newlyConstructed;
    if (this.tagFks != null) {
      data['tag_fks'] = this.tagFks!.map((v) => v.toJson()).toList();
    }
    data['space_max'] = this.spaceMax;
    data['area'] = this.area;
    data['city'] = this.city;
    data['country'] = this.country;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    return data;
  }

  @override
  decode(json) {
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    yearBuild = json['year_build'];
    spaceMin = json['space_min'];
    unit = json['unit'];
    newlyConstructed = json['newly_constructed'];
    if (json['tag_fks'] != null) {
      tagFks = <TagFks>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(TagFks.fromJson(v));
      });
    }
    spaceMax = json['space_max'];
    area = json['area'];
    city = json['city'];
    country = json['country'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
    userFk = json['user_fk'] != null ? UserFk.fromJson(json['user_fk']) : null;
    return this;
  }
}

class TagFks {
  int? id;
  String? tag;
  String? category;

  TagFks({this.id, this.tag, this.category});

  TagFks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['category'] = this.category;
    return data;
  }
}

class UserFk {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? country;
  String? photo;
  int? userType;
  String? cnic;
  String? phoneNumber;
  String? fullName;
  String? city;
  String? area;
  bool? isInvited;
  bool? isPasswordChanged;
  String? nationality;
  String? languages;
  String? createdAt;
  int? balance;
  bool? isVerifiedAgent;
  String? company;
  int? activeListingCount;
  int? totalListings;

  UserFk(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.address,
      this.country,
      this.photo,
      this.userType,
      this.cnic,
      this.phoneNumber,
      this.fullName,
      this.city,
      this.area,
      this.isInvited,
      this.isPasswordChanged,
      this.nationality,
      this.languages,
      this.createdAt,
      this.balance,
      this.isVerifiedAgent,
      this.company,
      this.activeListingCount,
      this.totalListings});

  UserFk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    country = json['country'];
    photo = json['photo'];
    userType = json['user_type'];
    cnic = json['cnic'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
    city = json['city'];
    area = json['area'];
    isInvited = json['is_invited'];
    isPasswordChanged = json['is_password_changed'];
    nationality = json['nationality'];
    languages = json['languages'];
    createdAt = json['created_at'];
    balance = json['balance'];
    isVerifiedAgent = json['is_verified_agent'];
    company = json['company'];
    activeListingCount = json['active_listing_count'];
    totalListings = json['total_listings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['country'] = this.country;
    data['photo'] = this.photo;
    data['user_type'] = this.userType;
    data['cnic'] = this.cnic;
    data['phone_number'] = this.phoneNumber;
    data['full_name'] = this.fullName;
    data['city'] = this.city;
    data['area'] = this.area;
    data['is_invited'] = this.isInvited;
    data['is_password_changed'] = this.isPasswordChanged;
    data['nationality'] = this.nationality;
    data['languages'] = this.languages;
    data['created_at'] = this.createdAt;
    data['balance'] = this.balance;
    data['is_verified_agent'] = this.isVerifiedAgent;
    data['company'] = this.company;
    data['active_listing_count'] = this.activeListingCount;
    data['total_listings'] = this.totalListings;
    return data;
  }
}
