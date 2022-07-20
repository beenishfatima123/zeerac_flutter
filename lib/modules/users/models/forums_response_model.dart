import 'package:zeerac_flutter/dio_networking/decodable.dart';

class ForumsResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<ForumModel>? results;

  ForumsResponseModel({this.count, this.next, this.previous, this.results});

  ForumsResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ForumModel>[];
      json['results'].forEach((v) {
        results!.add(new ForumModel.fromJson(v));
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
      results = <ForumModel>[];
      json['results'].forEach((v) {
        results!.add(new ForumModel.fromJson(v));
      });
    }
    return this;
  }
}

class ForumModel {
  int? id;
  String? title;
  String? content;

  /*List<Null>? likes;*/
  bool? isPrivate;
  String? groupPhoto;
  AuthorFk? authorFk;
  List<int>? members;
  String? updatedAt;
  int? repliesCount;
  int? likesCount;
  List<Replies>? replies;

  ForumModel(
      {this.id,
      this.title,
      this.content,
      //this.likes,
      this.isPrivate,
      this.groupPhoto,
      this.authorFk,
      this.members,
      this.updatedAt,
      this.repliesCount,
      this.likesCount,
      this.replies});

  ForumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    /*if (json['likes'] != null) {
      likes = <Null>[];
      json['likes'].forEach((v) {
        likes!.add(new Null.fromJson(v));
      });
    }*/
    isPrivate = json['is_private'];
    groupPhoto = json['group_photo'];
    authorFk = json['author_fk'] != null
        ? new AuthorFk.fromJson(json['author_fk'])
        : null;
    members = json['members'].cast<int>();
    updatedAt = json['updated_at'];
    repliesCount = json['replies_count'];
    likesCount = json['likes_count'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    /* if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }*/
    data['is_private'] = this.isPrivate;
    data['group_photo'] = this.groupPhoto;
    if (this.authorFk != null) {
      data['author_fk'] = this.authorFk!.toJson();
    }
    data['members'] = this.members;
    data['updated_at'] = this.updatedAt;
    data['replies_count'] = this.repliesCount;
    data['likes_count'] = this.likesCount;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuthorFk {
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

  AuthorFk(
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

  AuthorFk.fromJson(Map<String, dynamic> json) {
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

class Replies {
  int? id;
  String? content;

  /*List<Null>? likes;*/
  AuthorFk? authorFk;
  String? updatedAt;
  int? groupFk;
  int? likesCount;

  Replies(
      {this.id,
      this.content,
      //this.likes,
      this.authorFk,
      this.updatedAt,
      this.groupFk,
      this.likesCount});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    /* if (json['likes'] != null) {
      likes = <Null>[];
      json['likes'].forEach((v) {
        likes!.add(new Null.fromJson(v));
      });
    }*/
    authorFk = json['author_fk'] != null
        ? new AuthorFk.fromJson(json['author_fk'])
        : null;
    updatedAt = json['updated_at'];
    groupFk = json['group_fk'];
    likesCount = json['likes_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['content'] = this.content;
    /* if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }*/
    if (this.authorFk != null) {
      data['author_fk'] = this.authorFk!.toJson();
    }
    data['updated_at'] = this.updatedAt;
    data['group_fk'] = this.groupFk;
    data['likes_count'] = this.likesCount;
    return data;
  }
}
