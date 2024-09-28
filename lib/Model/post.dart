import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String groupId;
  final String authorId; // 작성자 UID
  final String title;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final int viewsCount;
  final int commentCount;

  Post({
    required this.postId,
    required this.groupId,
    required this.authorId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.likesCount,
    required this.viewsCount,
    required this.commentCount,
  });

  // Firestore 데이터를 Post 객체로 변환
  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    return Post(
      postId: id,
      groupId: data['groupId'] ?? '',
      authorId: data['authorId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likesCount: data['likesCount'] ?? 0,
      viewsCount: data['viewsCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
    );
  }

  // Post 객체를 Firestore로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'authorId': authorId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likesCount': likesCount,
      'viewsCount': viewsCount,
      'commentCount': commentCount,
    };
  }
}
