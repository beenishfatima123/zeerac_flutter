import 'package:zeerac_flutter/dio_networking/decodable.dart';

class ProjectsResponseModel implements Decodeable {
  int? id;
  String? title;
  String? locality;
  String? propertyType;
  String? logo;
  String? city;
  String? country;
  String? minPrice;
  String? maxPrice;
  String? propertyUrl;
  num? lat;
  num? lng;
  List<Content>? content;

  ProjectsResponseModel(
      {this.id,
      this.title,
      this.locality,
      this.propertyType,
      this.logo,
      this.city,
      this.country,
      this.minPrice,
      this.maxPrice,
      this.propertyUrl,
      this.lat,
      this.lng,
      this.content});

  ProjectsResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    locality = json['locality'];
    propertyType = json['property_type'];
    logo = json['logo'];
    city = json['city'];
    country = json['country'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    propertyUrl = json['property_url'];
    lat = json['lat'];
    lng = json['lng'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['locality'] = this.locality;
    data['property_type'] = this.propertyType;
    data['logo'] = this.logo;
    data['city'] = this.city;
    data['country'] = this.country;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['property_url'] = this.propertyUrl;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    title = json['title'];
    locality = json['locality'];
    propertyType = json['property_type'];
    logo = json['logo'];
    city = json['city'];
    country = json['country'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    propertyUrl = json['property_url'];
    lat = json['lat'];
    lng = json['lng'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
    return this;
  }
}

class Content {
  int? id;
  List<Files>? files;
  String? title;
  String? body;
  bool? containsFiles;

  Content({this.id, this.files, this.title, this.body, this.containsFiles});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    title = json['title'];
    body = json['body'];
    containsFiles = json['contains_files'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['body'] = this.body;
    data['contains_files'] = this.containsFiles;
    return data;
  }
}

class Files {
  int? id;
  String? fileType;
  String? fileName;
  String? file;
  String? createdAt;
  String? updatedAt;

  Files(
      {this.id,
      this.fileType,
      this.fileName,
      this.file,
      this.createdAt,
      this.updatedAt});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileType = json['file_type'];
    fileName = json['file_name'];
    file = json['file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_type'] = this.fileType;
    data['file_name'] = this.fileName;
    data['file'] = this.file;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
