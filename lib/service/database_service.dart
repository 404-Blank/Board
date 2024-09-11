import 'package:blank/Model/post.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  Future<void> createPost(Post post) async {
    final newPostRef = _ref.child('posts').push();
    post.id = newPostRef.key!;

    // created_at을 현재 시간의 타임스탬프로 저장
    await newPostRef.set({
      ...post.toMap(),
      'created_at': DateTime.now().millisecondsSinceEpoch, // 타임스탬프 저장
    });
  }

  Future<List<Post>> getPosts() async {
    final snapshot = await _ref
        .child('posts')
        .orderByChild('created_at') // created_at 기준으로 정렬
        .get(); // 데이터를 읽어옴

    if (snapshot.exists) {
      // snapshot.children을 사용하여 데이터를 정렬된 순서로 가져옴
      return snapshot.children
          .map((child) {
            final postData = Map<String, dynamic>.from(child.value as Map);
            return Post.fromMap(child.key!, postData);
          })
          .toList()
          .reversed
          .toList(); // 최신순으로 변환
    } else {
      return []; // 데이터가 없을 경우 빈 리스트 반환
    }
  }

// 게시글 스트림 가져오기
  Stream<List<Post>> getPostsStream() {
    return _ref
        .child('posts')
        .orderByChild('created_at') // created_at 기준으로 정렬
        .onValue
        .map((event) {
      final children = event.snapshot.children;

      return children
          .map((child) {
            final postData = Map<String, dynamic>.from(child.value as Map);
            return Post.fromMap(child.key!, postData);
          })
          .toList()
          .reversed
          .toList(); // 최신순으로 변환
    });
  }

  // 댓글 추가 메서드 (post/$postId/comments 경로에 댓글 추가)
  Future<void> addComment(String postId, String author, String content) async {
    // 댓글 추가
    final commentRef = _ref.child('posts/$postId/comments').push();
    await commentRef.set({
      'author': author,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });

    // 댓글 수를 증가시키기 위한 트랜잭션
    final postRef = _ref.child('posts/$postId');
    postRef.child('comment_count').runTransaction((currentValue) {
      final int currentCount = (currentValue as int?) ?? 0;
      return Transaction.success(currentCount + 1);
    });
  }

  // 특정 게시글의 댓글 불러오기
  Stream<List<Map<String, dynamic>>> getCommentsStream(String postId) {
    return _ref.child('posts/$postId/comments').onValue.map((event) {
      final Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) {
        return {
          'id': entry.key,
          'author': entry.value['author'],
          'content': entry.value['content'],
          'created_at': entry.value['created_at'],
        };
      }).toList();
    });
  }

  // 조회수 증가 메서드
  Future<void> incrementViewCount(String postId) async {
    final postRef = _ref.child('posts/$postId');
    postRef.child('views').runTransaction((currentValue) {
      final int currentViews = (currentValue as int?) ?? 0;
      return Transaction.success(currentViews + 1); // 조회수 1 증가
    });
  }
}
