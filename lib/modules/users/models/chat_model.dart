class ChatModel {
  String message;
  String fromId;
  String toId;
  String timeStamp;
  int type;

//<editor-fold desc="Data Methods">

  ChatModel({
    required this.message,
    required this.fromId,
    required this.toId,
    required this.timeStamp,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatModel &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          fromId == other.fromId &&
          toId == other.toId &&
          timeStamp == other.timeStamp &&
          type == other.type);

  @override
  int get hashCode =>
      message.hashCode ^
      fromId.hashCode ^
      toId.hashCode ^
      timeStamp.hashCode ^
      type.hashCode;

  @override
  String toString() {
    return 'ChatModel{' +
        ' message: $message,' +
        ' fromId: $fromId,' +
        ' toId: $toId,' +
        ' timeStamp: $timeStamp,' +
        ' type: $type,' +
        '}';
  }

  ChatModel copyWith({
    String? message,
    String? fromId,
    String? toId,
    String? timeStamp,
    int? type,
  }) {
    return ChatModel(
      message: message ?? this.message,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      timeStamp: timeStamp ?? this.timeStamp,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'fromId': this.fromId,
      'toId': this.toId,
      'timeStamp': this.timeStamp,
      'type': this.type,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map['message'] as String,
      fromId: map['fromId'] as String,
      toId: map['toId'] as String,
      timeStamp: map['timeStamp'],
      type: map['type'] as int,
    );
  }

//</editor-fold>
}
