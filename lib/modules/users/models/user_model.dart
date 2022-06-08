import 'package:zeerac_flutter/dio_networking/decodable.dart';

class UserModel implements Decodeable {
  String? token;
  int? id;
  String? username;
  String? email;
  String? created;
  bool? isAdmin;
  String? firstName;
  int? userType;
  bool? isActive;
  int? balance;
  bool? isPasswordChanged;
  String? photo;

  UserModel(
      {this.token,
      this.id,
      this.username,
      this.email,
      this.created,
      this.isAdmin,
      this.firstName,
      this.userType,
      this.isActive,
      this.balance,
      this.isPasswordChanged,
      this.photo});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    created = json['created'];
    isAdmin = json['is_admin'];
    firstName = json['first_name'];
    userType = json['user_type'];
    isActive = json['is_active'];
    balance = json['balance'];
    isPasswordChanged = json['is_password_changed'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['created'] = this.created;
    data['is_admin'] = this.isAdmin;
    data['first_name'] = this.firstName;
    data['user_type'] = this.userType;
    data['is_active'] = this.isActive;
    data['balance'] = this.balance;
    data['is_password_changed'] = this.isPasswordChanged;
    data['photo'] = this.photo;
    return data;
  }

  @override
  decode(json) {
    token = json['token'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    created = json['created'];
    isAdmin = json['is_admin'];
    firstName = json['first_name'];
    userType = json['user_type'];
    isActive = json['is_active'];
    balance = json['balance'];
    isPasswordChanged = json['is_password_changed'];
    photo = json['photo'];

    return this;
  }

  @override
  String toString() {
    return 'UserModel{token: $token, id: $id, username: $username, email: $email, created: $created, isAdmin: $isAdmin, firstName: $firstName, userType: $userType, isActive: $isActive, balance: $balance, isPasswordChanged: $isPasswordChanged, photo: $photo}';
  }
}
