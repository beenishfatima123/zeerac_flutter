import 'package:zeerac_flutter/dio_networking/decodable.dart';

class CompaniesResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<CompanyModel>? results;

  CompaniesResponseModel({this.count, this.next, this.previous, this.results});

  CompaniesResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <CompanyModel>[];
      json['results'].forEach((v) {
        results!.add(new CompanyModel.fromJson(v));
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
      results = <CompanyModel>[];
      json['results'].forEach((v) {
        results!.add(new CompanyModel.fromJson(v));
      });
    }
    return this;
  }
}

class CompanyModel {
  int? id;
  String? name;
  String? description;
  String? email;
  String? phone;
  String? fax;
  String? address;
  bool? isActive;
  String? logo;
  List<User>? user;
  Admin? admin;
  String? quote;
  String? history;
  int? soldListings;
  int? activeListings;
  Null? areas;
  Null? city;

  CompanyModel(
      {this.id,
      this.name,
      this.description,
      this.email,
      this.phone,
      this.fax,
      this.address,
      this.isActive,
      this.logo,
      this.user,
      this.admin,
      this.quote,
      this.history,
      this.soldListings,
      this.activeListings,
      this.areas,
      this.city});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    email = json['email'];
    phone = json['phone'];
    fax = json['fax'];
    address = json['address'];
    isActive = json['is_active'];
    logo = json['logo'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
    admin = json['admin'] != null ? new Admin.fromJson(json['admin']) : null;
    quote = json['quote'];
    history = json['history'];
    soldListings = json['sold_listings'];
    activeListings = json['active_listings'];
    areas = json['areas'];
    city = json['city'];
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
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    if (this.admin != null) {
      data['admin'] = this.admin!.toJson();
    }
    data['quote'] = this.quote;
    data['history'] = this.history;
    data['sold_listings'] = this.soldListings;
    data['active_listings'] = this.activeListings;
    data['areas'] = this.areas;
    data['city'] = this.city;
    return data;
  }
}

class User {
  int? id;
  String? password;
  Null? lastLogin;
  bool? isSuperuser;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? photo;
  int? userType;
  String? cnic;
  String? phoneNumber;
  String? city;
  String? area;
  Null? address;
  Null? resetPassToken;
  String? resetTokenCreatedAt;
  Null? country;
  Null? nationality;
  Null? languages;
  bool? isInvited;
  bool? isPasswordChanged;
  Null? balance;
  Null? areas;
  Null? currency;
  String? createdAt;
  Null? verifyAccountToken;
  String? accountTokenCreatedAt;
  bool? isVerified;
  List<Null>? groups;
  List<Null>? userPermissions;
  List<Null>? permissions;

  User(
      {this.id,
      this.password,
      this.lastLogin,
      this.isSuperuser,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.isStaff,
      this.isActive,
      this.dateJoined,
      this.photo,
      this.userType,
      this.cnic,
      this.phoneNumber,
      this.city,
      this.area,
      this.address,
      this.resetPassToken,
      this.resetTokenCreatedAt,
      this.country,
      this.nationality,
      this.languages,
      this.isInvited,
      this.isPasswordChanged,
      this.balance,
      this.areas,
      this.currency,
      this.createdAt,
      this.verifyAccountToken,
      this.accountTokenCreatedAt,
      this.isVerified,
      this.groups,
      this.userPermissions,
      this.permissions});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    photo = json['photo'];
    userType = json['user_type'];
    cnic = json['cnic'];
    phoneNumber = json['phone_number'];
    city = json['city'];
    area = json['area'];
    address = json['address'];
    resetPassToken = json['reset_pass_token'];
    resetTokenCreatedAt = json['reset_token_created_at'];
    country = json['country'];
    nationality = json['nationality'];
    languages = json['languages'];
    isInvited = json['is_invited'];
    isPasswordChanged = json['is_password_changed'];
    balance = json['balance'];
    areas = json['areas'];
    currency = json['currency'];
    createdAt = json['created_at'];
    verifyAccountToken = json['verify_account_token'];
    accountTokenCreatedAt = json['account_token_created_at'];
    isVerified = json['is_verified'];
/*    if (json['groups'] != null) {
      groups = <Null>[];
      json['groups'].forEach((v) {
        groups!.add(new Null.fromJson(v));
      });
    }
    if (json['user_permissions'] != null) {
      userPermissions = <Null>[];
      json['user_permissions'].forEach((v) {
        userPermissions!.add(new Null.fromJson(v));
      });
    }
    if (json['permissions'] != null) {
      permissions = <Null>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['last_login'] = this.lastLogin;
    data['is_superuser'] = this.isSuperuser;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['is_staff'] = this.isStaff;
    data['is_active'] = this.isActive;
    data['date_joined'] = this.dateJoined;
    data['photo'] = this.photo;
    data['user_type'] = this.userType;
    data['cnic'] = this.cnic;
    data['phone_number'] = this.phoneNumber;
    data['city'] = this.city;
    data['area'] = this.area;
    data['address'] = this.address;
    data['reset_pass_token'] = this.resetPassToken;
    data['reset_token_created_at'] = this.resetTokenCreatedAt;
    data['country'] = this.country;
    data['nationality'] = this.nationality;
    data['languages'] = this.languages;
    data['is_invited'] = this.isInvited;
    data['is_password_changed'] = this.isPasswordChanged;
    data['balance'] = this.balance;
    data['areas'] = this.areas;
    data['currency'] = this.currency;
    data['created_at'] = this.createdAt;
    data['verify_account_token'] = this.verifyAccountToken;
    data['account_token_created_at'] = this.accountTokenCreatedAt;
    data['is_verified'] = this.isVerified;
    /*if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    if (this.userPermissions != null) {
      data['user_permissions'] =
          this.userPermissions!.map((v) => v.toJson()).toList();
    }
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class Admin {
  int? id;
  String? password;
  String? lastLogin;
  bool? isSuperuser;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? photo;
  int? userType;
  String? cnic;
  String? phoneNumber;
  String? city;
  String? area;
  String? address;
  Null? resetPassToken;
  String? resetTokenCreatedAt;
  Null? country;
  Null? nationality;
  Null? languages;
  bool? isInvited;
  bool? isPasswordChanged;
  int? balance;
  Null? areas;
  Null? currency;
  String? createdAt;
  Null? verifyAccountToken;
  String? accountTokenCreatedAt;
  bool? isVerified;
  List<Null>? groups;
  List<Null>? userPermissions;
  List<Null>? permissions;

  Admin(
      {this.id,
      this.password,
      this.lastLogin,
      this.isSuperuser,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.isStaff,
      this.isActive,
      this.dateJoined,
      this.photo,
      this.userType,
      this.cnic,
      this.phoneNumber,
      this.city,
      this.area,
      this.address,
      this.resetPassToken,
      this.resetTokenCreatedAt,
      this.country,
      this.nationality,
      this.languages,
      this.isInvited,
      this.isPasswordChanged,
      this.balance,
      this.areas,
      this.currency,
      this.createdAt,
      this.verifyAccountToken,
      this.accountTokenCreatedAt,
      this.isVerified,
      this.groups,
      this.userPermissions,
      this.permissions});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    photo = json['photo'];
    userType = json['user_type'];
    cnic = json['cnic'];
    phoneNumber = json['phone_number'];
    city = json['city'];
    area = json['area'];
    address = json['address'];
    resetPassToken = json['reset_pass_token'];
    resetTokenCreatedAt = json['reset_token_created_at'];
    country = json['country'];
    nationality = json['nationality'];
    languages = json['languages'];
    isInvited = json['is_invited'];
    isPasswordChanged = json['is_password_changed'];
    balance = json['balance'];
    areas = json['areas'];
    currency = json['currency'];
    createdAt = json['created_at'];
    verifyAccountToken = json['verify_account_token'];
    accountTokenCreatedAt = json['account_token_created_at'];
    isVerified = json['is_verified'];
    /*if (json['groups'] != null) {
      groups = <Null>[];
      json['groups'].forEach((v) {
        groups!.add(new Null.fromJson(v));
      });
    }
    if (json['user_permissions'] != null) {
      userPermissions = <Null>[];
      json['user_permissions'].forEach((v) {
        userPermissions!.add(new Null.fromJson(v));
      });
    }
    if (json['permissions'] != null) {
      permissions = <Null>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['last_login'] = this.lastLogin;
    data['is_superuser'] = this.isSuperuser;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['is_staff'] = this.isStaff;
    data['is_active'] = this.isActive;
    data['date_joined'] = this.dateJoined;
    data['photo'] = this.photo;
    data['user_type'] = this.userType;
    data['cnic'] = this.cnic;
    data['phone_number'] = this.phoneNumber;
    data['city'] = this.city;
    data['area'] = this.area;
    data['address'] = this.address;
    data['reset_pass_token'] = this.resetPassToken;
    data['reset_token_created_at'] = this.resetTokenCreatedAt;
    data['country'] = this.country;
    data['nationality'] = this.nationality;
    data['languages'] = this.languages;
    data['is_invited'] = this.isInvited;
    data['is_password_changed'] = this.isPasswordChanged;
    data['balance'] = this.balance;
    data['areas'] = this.areas;
    data['currency'] = this.currency;
    data['created_at'] = this.createdAt;
    data['verify_account_token'] = this.verifyAccountToken;
    data['account_token_created_at'] = this.accountTokenCreatedAt;
    data['is_verified'] = this.isVerified;
    /*if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    if (this.userPermissions != null) {
      data['user_permissions'] =
          this.userPermissions!.map((v) => v.toJson()).toList();
    }
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
