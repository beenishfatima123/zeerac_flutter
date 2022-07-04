class FirebaseUserModel {
  String? username;
  String? emailForFirebase;
  String? deviceToken = '';
  String? uid;
  bool isOnline = true;
  String? password;

//<editor-fold desc="Data Methods">

  FirebaseUserModel({
    this.username,
    this.emailForFirebase,
    this.deviceToken,
    this.password,
    this.uid,
    this.isOnline = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FirebaseUserModel &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          emailForFirebase == other.emailForFirebase &&
          deviceToken == other.deviceToken &&
          uid == other.uid &&
          isOnline == other.isOnline);

  @override
  int get hashCode =>
      username.hashCode ^
      emailForFirebase.hashCode ^
      deviceToken.hashCode ^
      uid.hashCode ^
      isOnline.hashCode;

  @override
  String toString() {
    return 'FirebaseUserModel{' +
        ' username: $username,' +
        ' emailForFirebase: $emailForFirebase,' +
        ' deviceToken: $deviceToken,' +
        ' uid: $uid,' +
        ' isOnline: $isOnline,' +
        '}';
  }

  FirebaseUserModel copyWith({
    String? username,
    String? emailForFirebase,
    String? deviceToken,
    String? uid,
    bool? isOnline,
  }) {
    return FirebaseUserModel(
      username: username ?? this.username,
      emailForFirebase: emailForFirebase ?? this.emailForFirebase,
      deviceToken: deviceToken ?? this.deviceToken,
      uid: uid ?? this.uid,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'emailForFirebase': this.emailForFirebase,
      'deviceToken': this.deviceToken,
      'uid': this.uid,
      'isOnline': this.isOnline,
    };
  }

  factory FirebaseUserModel.fromMap(Map<String, dynamic> map) {
    return FirebaseUserModel(
      username: map['username'] as String,
      emailForFirebase: map['emailForFirebase'] as String,
      deviceToken: map['deviceToken'] as String,
      uid: map['uid'] as String,
      isOnline: map['isOnline'] as bool,
    );
  }

/*  S
  //</editor-fold>
tring? password;*/

}
