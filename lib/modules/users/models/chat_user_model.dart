class ChatUserModel {
  String? otherUserId;
  String? otherUserName;
  String? otherUserContact;
  String? otherUserProfileImage;

//<editor-fold desc="Data Methods">

  ChatUserModel({
    this.otherUserId,
    this.otherUserName,
    this.otherUserContact,
    this.otherUserProfileImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatUserModel &&
          runtimeType == other.runtimeType &&
          otherUserId == other.otherUserId &&
          otherUserName == other.otherUserName &&
          otherUserContact == other.otherUserContact &&
          otherUserProfileImage == other.otherUserProfileImage);

  @override
  int get hashCode =>
      otherUserId.hashCode ^
      otherUserName.hashCode ^
      otherUserContact.hashCode ^
      otherUserProfileImage.hashCode;

  @override
  String toString() {
    return 'ChatUserModel{' +
        ' userId: $otherUserId,' +
        ' userName: $otherUserName,' +
        ' userContact: $otherUserContact,' +
        ' userProfileImage: $otherUserProfileImage,' +
        '}';
  }

  ChatUserModel copyWith({
    String? userId,
    String? userName,
    String? userContact,
    String? userProfileImage,
  }) {
    return ChatUserModel(
      otherUserId: userId ?? this.otherUserId,
      otherUserName: userName ?? this.otherUserName,
      otherUserContact: userContact ?? this.otherUserContact,
      otherUserProfileImage: userProfileImage ?? this.otherUserProfileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.otherUserId,
      'userName': this.otherUserName,
      'userContact': this.otherUserContact,
      'userProfileImage': this.otherUserProfileImage,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      otherUserId: map['userId'] as String,
      otherUserName: map['userName'] as String,
      otherUserContact: map['userContact'] as String,
      otherUserProfileImage: map['userProfileImage'] as String,
    );
  }

//</editor-fold>
}
