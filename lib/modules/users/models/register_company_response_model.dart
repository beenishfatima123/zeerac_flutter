import 'package:zeerac_flutter/dio_networking/decodable.dart';

class RegisterCompanyResponse implements Decodeable {
  int? id;
  String? name;
  String? description;
  String? email;
  String? phone;
  String? fax;
  String? address;
  bool? isActive;
  String? logo;

  //List<>? user;
  int? admin;
  String? quote;
  String? history;
  String? areas;

  RegisterCompanyResponse(
      {this.id,
      this.name,
      this.description,
      this.email,
      this.phone,
      this.fax,
      this.address,
      this.isActive,
      this.logo,
      //this.user,
      this.admin,
      this.quote,
      this.history,
      this.areas});

  RegisterCompanyResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    email = json['email'];
    phone = json['phone'];
    fax = json['fax'];
    address = json['address'];
    isActive = json['is_active'];
    logo = json['logo'];
    /* if (json['user'] != null) {
      user = <Null>[];
      json['user'].forEach((v) {
        user!.add(new Null.fromJson(v));
      });
    }*/
    admin = json['admin'];
    quote = json['quote'];
    history = json['history'];
    areas = json['areas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fax'] = this.fax;
    data['address'] = this.address;
    data['is_active'] = this.isActive;
    data['logo'] = this.logo;
    /*if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }*/
    data['admin'] = this.admin;
    data['quote'] = this.quote;
    data['history'] = this.history;
    data['areas'] = this.areas;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    email = json['email'];
    phone = json['phone'];
    fax = json['fax'];
    address = json['address'];
    isActive = json['is_active'];
    logo = json['logo'];
    /* if (json['user'] != null) {
      user = <Null>[];
      json['user'].forEach((v) {
        user!.add(new Null.fromJson(v));
      });
    }*/
    admin = json['admin'];
    quote = json['quote'];
    history = json['history'];
    areas = json['areas'];
    return this;
  }
}
