import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_preference_post_response_model.dart';

import 'companies_response_model.dart';

class PropertyListingResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<PropertyModel>? results;

  PropertyListingResponseModel(
      {this.count, this.next, this.previous, this.results});

  PropertyListingResponseModel.fromJson(Map<String, dynamic> json) {
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

class PropertyModel implements Decodeable {
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
  UserModel? user;
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
  List<TagFks>? tagFks;
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
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
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

    if (json['tag_fks'] != null) {
      tagFks = <TagFks>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(new TagFks.fromJson(v));
      });
    }
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
    if (this.tagFks != null) {
      data['tag_fks'] = this.tagFks!.map((v) => v.toJson()).toList();
    }
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
    return 'Results{id: $id, name: $name, purpose: $purpose, type: $type, price: $price, period: $period, space: $space, country: $country, description: $description, video: $video, propertyId: $propertyId, beds: $beds, bathrooms: $bathrooms, lat: $lat, lng: $lng, condition: $condition, year: $year, neighborhood: $neighborhood, region: $region, spaceSqft: $spaceSqft, user: $user, predictedPrice: $predictedPrice, thumbnail: $thumbnail, address: $address, company: $company, features: $features, city: $city, createdAt: $createdAt, area: $area, loca: $loca, unit: $unit, isActiveListing: $isActiveListing, tagFks: , searchCount: $searchCount, currency: $currency, block: $block, isSold: $isSold, image: $image}';
  }

  @override
  decode(json) {
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
    user = ((json['user'] != null) && (json['user'].runtimeType == Object))
        ? UserModel.fromJson(json['user'])
        : null;
    predictedPrice = json['predicted_price'];
    thumbnail = json['thumbnail'];
    address = json['address'];
    company = json['company'];
    features =
        json['features'] != null ? Features.fromJson(json['features']) : null;
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

    return this;
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
