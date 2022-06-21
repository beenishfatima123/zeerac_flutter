import 'package:zeerac_flutter/dio_networking/decodable.dart';

class AgentsListingResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<AgentsModel>? results;

  AgentsListingResponseModel(
      {this.count, this.next, this.previous, this.results});

  AgentsListingResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <AgentsModel>[];
      json['results'].forEach((v) {
        results!.add(new AgentsModel.fromJson(v));
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
      results = <AgentsModel>[];
      json['results'].forEach((v) {
        results!.add(new AgentsModel.fromJson(v));
      });
    }
    return this;
  }
}

class AgentsModel {
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
  String? company;
  int? activeListingCount;
  int? totalListings;

  AgentsModel(
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
      this.company,
      this.activeListingCount,
      this.totalListings});

  AgentsModel.fromJson(Map<String, dynamic> json) {
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
    data['company'] = this.company;
    data['active_listing_count'] = this.activeListingCount;
    data['total_listings'] = this.totalListings;
    return data;
  }
}
