import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/social_group_response_model.dart';

class GroupMembersRequestResponseModel implements Decodeable {
  int? id;
  String? groupName;
  String? groupId;
  String? description;
  String? createdAt;
  String? updatedAt;
  AdminFk? adminFk;
  String? groupPhoto;
  int? membersPostsCount;

//  List<Null>? membersPosts;
  List<int>? members;
  int? membersCount;
  List<MembersRequests>? membersRequests;

  GroupMembersRequestResponseModel(
      {this.id,
      this.groupName,
      this.groupId,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.adminFk,
      this.groupPhoto,
      this.membersPostsCount,
      //this.membersPosts,
      this.members,
      this.membersCount,
      this.membersRequests});

  GroupMembersRequestResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    groupId = json['group_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminFk = json['admin_fk'] != null
        ? new AdminFk.fromJson(json['admin_fk'])
        : null;
    groupPhoto = json['group_photo'];
    membersPostsCount = json['members_posts_count'];
    /*if (json['members_posts'] != null) {
      //membersPosts = <Null>[];
      json['members_posts'].forEach((v) {
        //membersPosts!.add(new Null.fromJson(v));
      });
    }*/
    members = json['members'].cast<int>();
    membersCount = json['members_count'];
    if (json['members_requests'] != null) {
      membersRequests = <MembersRequests>[];
      json['members_requests'].forEach((v) {
        membersRequests!.add(new MembersRequests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_name'] = this.groupName;
    data['group_id'] = this.groupId;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.adminFk != null) {
      data['admin_fk'] = this.adminFk!.toJson();
    }
    data['group_photo'] = this.groupPhoto;
    data['members_posts_count'] = this.membersPostsCount;
    /*  if (this.membersPosts != null) {
      data['members_posts'] =
          this.membersPosts!.map((v) => v.toJson()).toList();
    }*/
    data['members'] = this.members;
    data['members_count'] = this.membersCount;
    if (this.membersRequests != null) {
      data['members_requests'] =
          this.membersRequests!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    groupName = json['group_name'];
    groupId = json['group_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminFk =
        json['admin_fk'] != null ? AdminFk.fromJson(json['admin_fk']) : null;
    groupPhoto = json['group_photo'];
    membersPostsCount = json['members_posts_count'];
    /*if (json['members_posts'] != null) {
      //membersPosts = <Null>[];
      json['members_posts'].forEach((v) {
        //membersPosts!.add(new Null.fromJson(v));
      });
    }*/
    members = json['members'].cast<int>();
    membersCount = json['members_count'];
    if (json['members_requests'] != null) {
      membersRequests = <MembersRequests>[];
      json['members_requests'].forEach((v) {
        membersRequests!.add(MembersRequests.fromJson(v));
      });
    }
    return this;
  }
}

class MembersRequests {
  int? id;
  bool? approved;
  String? updatedAt;
  int? memberFk;
  int? groupFk;
  String? memberName;
  String? memberPhoto;

  MembersRequests(
      {this.id,
      this.approved,
      this.updatedAt,
      this.memberFk,
      this.groupFk,
      this.memberName,
      this.memberPhoto});

  MembersRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    approved = json['approved'];
    updatedAt = json['updated_at'];
    memberFk = json['member_fk'];
    groupFk = json['group_fk'];
    memberName = json['member_name'];
    memberPhoto = json['member_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['approved'] = this.approved;
    data['updated_at'] = this.updatedAt;
    data['member_fk'] = this.memberFk;
    data['group_fk'] = this.groupFk;
    data['member_name'] = this.memberName;
    data['member_photo'] = this.memberPhoto;
    return data;
  }
}
