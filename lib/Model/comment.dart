import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String authorId; // 작성자 UID
  final String content;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  // Firestore 데이터를 Comment 객체로 변환
  factory Comment.fromFirestore(Map<String, dynamic> data, String id) {
    return Comment(
      commentId: id,
      authorId: data['authorId'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Comment 객체를 Firestore로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
