class Chat {
  String chatRoomId;
  String chatName;
  List<String> participants;
  String? lastMessage;
  DateTime? lastMessageTime;
  String chatType;
  List<String> admins;
  String? chatDiscription;
  Chat({
    required this.chatRoomId,
    required this.chatName,
    required this.admins,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    required this.chatType,
    this.chatDiscription,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'chatName': chatName,
      'admins': admins,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
      'chatType': chatType,
      'chatdiscription': chatDiscription,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      chatRoomId: map['chatRoomId'],
      chatName: map['chatName'],
      admins: List<String>.from(map['admins']),
      participants: List<String>.from(map['participants']),
      lastMessage: map['lastMessage'],
      lastMessageTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime']),
      chatType: map['chatType'],
      chatDiscription: map['chatDiscription'],
    );
  }
}
