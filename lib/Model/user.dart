class UserModel {
  final String userId;
  final String displayName;
  final String email;
  final String? photoURL; // 선택 사항이므로 nullable로 설정
  final List<String> groups; // 사용자가 속한 그룹 ID 목록
  final List<String> pendingInvitations; // 초대된 그룹 ID 목록

  UserModel({
    required this.userId,
    required this.displayName,
    required this.email,
    this.photoURL,
    required this.groups,
    required this.pendingInvitations,
  });

  // Firestore 데이터를 UserModel 객체로 변환
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      userId: id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoURL: data['photoURL'],
      groups: List<String>.from(data['groups'] ?? []),
      pendingInvitations: List<String>.from(data['pendingInvitations'] ?? []),
    );
  }

  // UserModel 객체를 Firestore로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'groups': groups,
      'pendingInvitations': pendingInvitations,
    };
  }
}
