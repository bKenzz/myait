class Group {
  String id;
  String groupName;
  String groupPicture;
  List<String> participants;
  List<String> admins;

  Group({
    required this.id,
    required this.groupName,
    required this.groupPicture,
    required this.participants,
    required this.admins,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupName': groupName,
      'groupPicture': groupPicture,
      'participants': participants,
      'admins': admins,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      groupName: map['groupName'],
      groupPicture: map['groupPicture'],
      participants: List<String>.from(map['participants']),
      admins: List<String>.from(map['admins']),
    );
  }
}
