import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_preference_post_response_model.dart';

class SocialPostsResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<SocialPostModel>? results;

  SocialPostsResponseModel(
      {this.count, this.next, this.previous, this.results});

  SocialPostsResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <SocialPostModel>[];
      json['results'].forEach((v) {
        results!.add(new SocialPostModel.fromJson(v));
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
      results = <SocialPostModel>[];
      json['results'].forEach((v) {
        results!.add(SocialPostModel.fromJson(v));
      });
    }
    return this;
  }
}

class SocialPostModel {
  int? id;
  String? description;
  String? link;
  String? propertyPostImage;
  String? createdAt;
  String? updatedAt;
  UserFk? userFk;
  int? commentsCount;
  int? likesCount;
  List<Comments> comments = [];
  List<LikesModel> likes = [];

  SocialPostModel(
      {this.id,
      this.description,
      this.link,
      this.propertyPostImage,
      this.createdAt,
      this.updatedAt,
      this.userFk,
      this.commentsCount,
      this.likesCount,
      this.comments = const [],
      this.likes = const []});

  SocialPostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    link = json['link'];
    propertyPostImage = json['property_post_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userFk =
        json['user_fk'] != null ? new UserFk.fromJson(json['user_fk']) : null;
    commentsCount = json['comments_count'];
    likesCount = json['likes_count'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    if (json['likes'] != null) {
      likes = <LikesModel>[];
      json['likes'].forEach((v) {
        likes.add(new LikesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['link'] = this.link;
    data['property_post_image'] = this.propertyPostImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    data['comments_count'] = this.commentsCount;
    data['likes_count'] = this.likesCount;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.likes != null) {
      data['likes'] = this.likes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments implements Decodeable {
  int? id;
  String? content;
  String? createdAt;
  String? updatedAt;

  //List<Null>? commentReplies;
  UserFk? userFk;
  int? propertyPostsFk;

  //Null? parentId;
  int? likesCount;
  List<LikesModel>? likes;

  Comments(
      {this.id,
      this.content,
      this.createdAt,
      this.updatedAt,
      //this.commentReplies,
      this.userFk,
      this.propertyPostsFk,
      //this.parentId,
      this.likesCount,
      this.likes});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['comment_replies'] != null) {
      //commentReplies = <Null>[];
      json['comment_replies'].forEach((v) {
        //commentReplies!.add(new Null.fromJson(v));
      });
    }
    userFk =
        json['user_fk'] != null ? new UserFk.fromJson(json['user_fk']) : null;
    propertyPostsFk = json['property_posts_fk'];
    // parentId = json['parent_id'];
    likesCount = json['likes_count'];
    if (json['likes'] != null) {
      likes = <LikesModel>[];
      json['likes'].forEach((v) {
        likes!.add(new LikesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /* if (this.commentReplies != null) {
      data['comment_replies'] =
          this.commentReplies!.map((v) => v.toJson()).toList();
    }*/
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    data['property_posts_fk'] = this.propertyPostsFk;
    //data['parent_id'] = this.parentId;
    data['likes_count'] = this.likesCount;
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['comment_replies'] != null) {
      //commentReplies = <Null>[];
      json['comment_replies'].forEach((v) {
        //commentReplies!.add(new Null.fromJson(v));
      });
    }
    userFk =
        json['user_fk'] != null ? new UserFk.fromJson(json['user_fk']) : null;
    propertyPostsFk = json['property_posts_fk'];
    // parentId = json['parent_id'];
    likesCount = json['likes_count'];
    if (json['likes'] != null) {
      likes = <LikesModel>[];
      json['likes'].forEach((v) {
        likes!.add(new LikesModel.fromJson(v));
      });
    }
    return this;
  }
}

class LikesModel implements Decodeable {
  int? id;
  bool? like;
  bool? dislike;
  String? createdAt;
  String? updatedAt;
  int? userFk;
  int? propertyPostsFk;
  int? commentFk;

  LikesModel(
      {this.id,
      this.like,
      this.dislike,
      this.createdAt,
      this.updatedAt,
      this.userFk,
      this.propertyPostsFk,
      this.commentFk});

  LikesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    like = json['like'];
    dislike = json['dislike'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userFk = json['user_fk'];
    propertyPostsFk = json['property_posts_fk'];
    commentFk = json['comment_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['like'] = this.like;
    data['dislike'] = this.dislike;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_fk'] = this.userFk;
    data['property_posts_fk'] = this.propertyPostsFk;
    data['comment_fk'] = this.commentFk;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    like = json['like'];
    dislike = json['dislike'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userFk = json['user_fk'];
    propertyPostsFk = json['property_posts_fk'];
    commentFk = json['comment_fk'];
    return this;
  }
}
