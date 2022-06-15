import 'package:zeerac_flutter/dio_networking/decodable.dart';

class PropertyListingModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<PropertyModel>? results;

  PropertyListingModel({this.count, this.next, this.previous, this.results});

  PropertyListingModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <PropertyModel>[];
      json['results'].forEach((v) {
        results!.add(new PropertyModel.fromJson(v));
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
      results = <PropertyModel>[];
      json['results'].forEach((v) {
        results!.add(new PropertyModel.fromJson(v));
      });
    }
    return this;
  }

  @override
  String toString() {
    return 'PropertyListingModel{count: $count, next: $next, previous: $previous, results: $results}';
  }
}

class PropertyModel {
  int? id;
  String? name;
  String? purpose;
  String? type;
  String? price;
  String? period;
  String? space;
  String? country;
  String? description;
  String? video;
  String? propertyId;
  int? beds;
  int? bathrooms;
  double? lat;
  double? lng;
  String? condition;
  int? year;
  String? neighborhood;
  String? region;
  int? spaceSqft;
  User? user;
  int? predictedPrice;
  String? thumbnail;
  String? address;
  String? company;
  Features? features;
  String? city;
  String? createdAt;
  String? area;
  String? loca;
  String? unit;
  bool? isActiveListing;
  List<String>? tagFks;
  int? searchCount;
  String? currency;
  String? block;
  bool? isSold;
  List<Image> image = const [];

  PropertyModel(
      {this.id,
      this.name,
      this.purpose,
      this.type,
      this.price,
      this.period,
      this.space,
      this.country,
      this.description,
      this.video,
      this.propertyId,
      this.beds,
      this.bathrooms,
      this.lat,
      this.lng,
      this.condition,
      this.year,
      this.neighborhood,
      this.region,
      this.spaceSqft,
      this.user,
      this.predictedPrice,
      this.thumbnail,
      this.address,
      this.company,
      this.features,
      this.city,
      this.createdAt,
      this.area,
      this.loca,
      this.unit,
      this.isActiveListing,
      this.tagFks,
      this.searchCount,
      this.currency,
      this.block,
      this.isSold,
      this.image = const []});

  PropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    purpose = json['purpose'];
    type = json['type'];
    price = json['price'];
    period = json['period'];
    space = json['space'];
    country = json['country'];
    description = json['description'];
    video = json['video'];
    propertyId = json['property_id'];
    beds = json['beds'];
    bathrooms = json['bathrooms'];
    lat = json['lat'];
    lng = json['lng'];
    condition = json['condition'];
    year = json['year'];
    neighborhood = json['neighborhood'];
    region = json['region'];
    spaceSqft = json['space_sqft'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    predictedPrice = json['predicted_price'];
    thumbnail = json['thumbnail'];
    address = json['address'];
    company = json['company'];
    features = json['features'] != null
        ? new Features.fromJson(json['features'])
        : null;
    city = json['city'];
    createdAt = json['created_at'];
    area = json['area'];
    loca = json['loca'];
    unit = json['unit'];
    isActiveListing = json['is_active_listing'];
    /*if (json['tag_fks'] != null) {
      tagFks = <Null>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(new Null.fromJson(v));
      });
    }*/
    searchCount = json['search_count'];
    currency = json['currency'];
    block = json['block'];
    isSold = json['is_sold'];
    if (json['image'] != null) {
      image = <Image>[];
      json['image'].forEach((v) {
        image.add(Image.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['purpose'] = this.purpose;
    data['type'] = this.type;
    data['price'] = this.price;
    data['period'] = this.period;
    data['space'] = this.space;
    data['country'] = this.country;
    data['description'] = this.description;
    data['video'] = this.video;
    data['property_id'] = this.propertyId;
    data['beds'] = this.beds;
    data['bathrooms'] = this.bathrooms;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['condition'] = this.condition;
    data['year'] = this.year;
    data['neighborhood'] = this.neighborhood;
    data['region'] = this.region;
    data['space_sqft'] = this.spaceSqft;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['predicted_price'] = this.predictedPrice;
    data['thumbnail'] = this.thumbnail;
    data['address'] = this.address;
    data['company'] = this.company;
    if (this.features != null) {
      data['features'] = this.features!.toJson();
    }
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    data['area'] = this.area;
    data['loca'] = this.loca;
    data['unit'] = this.unit;
    data['is_active_listing'] = this.isActiveListing;
    /* if (this.tagFks != null) {
      data['tag_fks'] = this.tagFks!.map((v) => v.toJson()).toList();
    }*/
    data['search_count'] = this.searchCount;
    data['currency'] = this.currency;
    data['block'] = this.block;
    data['is_sold'] = this.isSold;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Results{id: $id, name: $name, purpose: $purpose, type: $type, price: $price, period: $period, space: $space, country: $country, description: $description, video: $video, propertyId: $propertyId, beds: $beds, bathrooms: $bathrooms, lat: $lat, lng: $lng, condition: $condition, year: $year, neighborhood: $neighborhood, region: $region, spaceSqft: $spaceSqft, user: $user, predictedPrice: $predictedPrice, thumbnail: $thumbnail, address: $address, company: $company, features: $features, city: $city, createdAt: $createdAt, area: $area, loca: $loca, unit: $unit, isActiveListing: $isActiveListing, tagFks: $tagFks, searchCount: $searchCount, currency: $currency, block: $block, isSold: $isSold, image: $image}';
  }
}

class User {
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
  String? resetPassToken;
  String? resetTokenCreatedAt;
  String? country;
  String? nationality;
  String? languages;
  bool? isInvited;
  bool? isPasswordChanged;
  int? balance;
  String? areas;
  String? currency;
  String? createdAt;
  String? verifyAccountToken;
  String? accountTokenCreatedAt;
  bool? isVerified;
  List<String>? groups;
  List<String>? userPermissions;
  List<String>? permissions;
  String? company;

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
      this.permissions,
      this.company});

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
    resetPassToken = json['reset_pass_token'].toString();
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
    verifyAccountToken = json['verify_account_token'].toString();
    accountTokenCreatedAt = json['account_token_created_at'];
    isVerified = json['is_verified'];
    /*if (json['groups'] != null) {
      groups = <Null>[];
      json['groups'].forEach((v) {
        groups!.add(new Null.fromJson(v));
      });
    }*/
    /*if (json['user_permissions'] != null) {
      userPermissions = <Null>[];
      json['user_permissions'].forEach((v) {
        userPermissions!.add(new Null.fromJson(v));
      });
    }*/
    /*if (json['permissions'] != null) {
      permissions = <Null>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Null.fromJson(v));
      });
    }*/
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
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
    data['company'] = this.company;
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, password: $password, lastLogin: $lastLogin, isSuperuser: $isSuperuser, username: $username, firstName: $firstName, lastName: $lastName, email: $email, isStaff: $isStaff, isActive: $isActive, dateJoined: $dateJoined, photo: $photo, userType: $userType, cnic: $cnic, phoneNumber: $phoneNumber, city: $city, area: $area, address: $address, resetPassToken: $resetPassToken, resetTokenCreatedAt: $resetTokenCreatedAt, country: $country, nationality: $nationality, languages: $languages, isInvited: $isInvited, isPasswordChanged: $isPasswordChanged, balance: $balance, areas: $areas, currency: $currency, createdAt: $createdAt, verifyAccountToken: $verifyAccountToken, accountTokenCreatedAt: $accountTokenCreatedAt, isVerified: $isVerified, groups: $groups, userPermissions: $userPermissions, permissions: $permissions, company: $company}';
  }
}

class Features {
  int? id;
  bool? furnished;
  bool? parking;
  bool? electricity;
  bool? suigas;
  bool? landline;
  bool? sewerage;
  bool? internet;

  Features(
      {this.id,
      this.furnished,
      this.parking,
      this.electricity,
      this.suigas,
      this.landline,
      this.sewerage,
      this.internet});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    furnished = json['furnished'];
    parking = json['parking'];
    electricity = json['electricity'];
    suigas = json['suigas'];
    landline = json['landline'];
    sewerage = json['sewerage'];
    internet = json['internet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['furnished'] = this.furnished;
    data['parking'] = this.parking;
    data['electricity'] = this.electricity;
    data['suigas'] = this.suigas;
    data['landline'] = this.landline;
    data['sewerage'] = this.sewerage;
    data['internet'] = this.internet;
    return data;
  }

  @override
  String toString() {
    return 'Features{id: $id, furnished: $furnished, parking: $parking, electricity: $electricity, suigas: $suigas, landline: $landline, sewerage: $sewerage, internet: $internet}';
  }
}

class Image {
  String? image;
  int? id;

  Image({this.image, this.id});

  Image.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}
