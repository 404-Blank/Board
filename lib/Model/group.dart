class Group {
  final String groupId;
  final String groupName;
  final String groupDescription;
  final String mainImage;
  final String createdBy; // user.ref로 사용자의 UID 저장
  final List<String> members; // 사용자의 UID 목록
  final List<String> invitedUsers; // 초대된 사용자의 UID 목록

  Group({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.mainImage,
    required this.createdBy,
    required this.members,
    required this.invitedUsers,
  });

  // Firestore 데이터를 Group 객체로 변환
  factory Group.fromFirestore(Map<String, dynamic> data, String id) {
    return Group(
      groupId: id,
      groupName: data['groupName'] ?? '',
      groupDescription: data['groupDescription'] ?? '',
      mainImage: data['mainImage'] ?? '',
      createdBy: data['createdBy'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      invitedUsers: List<String>.from(data['invitedUsers'] ?? []),
    );
  }

  // Group 객체를 Firestore로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'groupName': groupName,
      'groupDescription': groupDescription,
      'mainImage': mainImage,
      'createdBy': createdBy,
      'members': members,
      'invitedUsers': invitedUsers,
    };
  }
}
