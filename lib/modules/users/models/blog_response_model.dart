import 'package:zeerac_flutter/dio_networking/decodable.dart';

class BlogResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<BlogModel>? results;

  BlogResponseModel({this.count, this.next, this.previous, this.results});

  BlogResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <BlogModel>[];
      json['results'].forEach((v) {
        results!.add(new BlogModel.fromJson(v));
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
      results = <BlogModel>[];
      json['results'].forEach((v) {
        results!.add(new BlogModel.fromJson(v));
      });
    }
    return this;
  }
}

class BlogModel {
  int? id;
  String? title;
  String? description;
  String? content;
  String? tags;
  String? references;
  int? author;
  String? createdAt;
  String? blogPhoto;
  String? authorPhoto;
  String? authorName;

  BlogModel(
      {this.id,
      this.title,
      this.description,
      this.content,
      this.tags,
      this.references,
      this.author,
      this.createdAt,
      this.blogPhoto,
      this.authorPhoto,
      this.authorName});

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    content = json['content'];
    tags = json['tags'];
    references = json['references'];
    author = json['author'];
    createdAt = json['created_at'];
    blogPhoto = json['blog_photo'];
    authorPhoto = json['author_photo'];
    authorName = json['author_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['tags'] = this.tags;
    data['references'] = this.references;
    data['author'] = this.author;
    data['created_at'] = this.createdAt;
    data['blog_photo'] = this.blogPhoto;
    data['author_photo'] = this.authorPhoto;
    data['author_name'] = this.authorName;
    return data;
  }
}
