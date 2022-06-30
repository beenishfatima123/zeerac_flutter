class FirebaseUser {
  String name;
  String image;
  String id;
  String lastMessage;
  String time;
  String mobile;

//<editor-fold desc="Data Methods">

  FirebaseUser({
    required this.name,
    required this.image,
    required this.id,
    required this.lastMessage,
    required this.time,
    required this.mobile,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FirebaseUser &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image &&
          id == other.id &&
          lastMessage == other.lastMessage &&
          time == other.time &&
          mobile == other.mobile);

  @override
  int get hashCode =>
      name.hashCode ^
      image.hashCode ^
      id.hashCode ^
      lastMessage.hashCode ^
      time.hashCode ^
      mobile.hashCode;

  @override
  String toString() {
    return 'FirebaseUser{' +
        ' name: $name,' +
        ' image: $image,' +
        ' id: $id,' +
        ' lastMessage: $lastMessage,' +
        ' time: $time,' +
        ' mobile: $mobile,' +
        '}';
  }

  FirebaseUser copyWith({
    String? name,
    String? image,
    String? id,
    String? lastMessage,
    String? time,
    String? mobile,
  }) {
    return FirebaseUser(
      name: name ?? this.name,
      image: image ?? this.image,
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      mobile: mobile ?? this.mobile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'image': this.image,
      'id': this.id,
      'lastMessage': this.lastMessage,
      'time': this.time,
      'mobile': this.mobile,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      name: map['name'] as String,
      image: map['image'] as String,
      id: map['id'] as String,
      lastMessage: map['lastMessage'] as String,
      time: map['time'] as String,
      mobile: map['mobile'] as String,
    );
  }

//</editor-fold>
}
