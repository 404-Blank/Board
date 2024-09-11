class Post {
  String id;
  String author;
  String category;
  String title;
  String content;
  int createdAt;
  int views;
  int likes;
  int commentCount; // 댓글 수 추가

  Post({
    required this.id,
    required this.author,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
    this.views = 0,
    this.likes = 0,
    this.commentCount = 0, // 기본값 0
  });

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'category': category,
      'title': title,
      'content': content,
      'created_at': createdAt,
      'views': views,
      'likes': likes,
      'comment_count': commentCount, // 댓글 수 저장
    };
  }

  static Post fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      author: map['author'],
      category: map['category'],
      title: map['title'],
      content: map['content'],
      createdAt: map['created_at'],
      views: map['views'],
      likes: map['likes'],
      commentCount: map['comment_count'] ?? 0, // 댓글 수 로드
    );
  }

  String get formattedCreatedAt {
    final date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
  }
}
