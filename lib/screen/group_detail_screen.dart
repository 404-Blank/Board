import 'package:blank/service/invitation_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => GroupDetailScreenState();
}

class GroupDetailScreenState extends State<GroupDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // 댓글 추가 메서드
  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // 로그인하지 않은 상태에서는 댓글 작성 불가
    }

    // Firestore에 댓글 추가
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('comments')
        .add({
      'commentText': _commentController.text.trim(),
      'commentedBy': user.displayName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 댓글 작성 후 입력 필드 초기화
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    InvitationService invitationService = InvitationService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 상세'),
        actions: [
          TextButton(
              onPressed: () {
                invitationService.inviteToGroup(widget.groupId);
              },
              child: const Text("초대하기")),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('댓글이 없습니다.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var comment = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(comment['commentText']),
                        subtitle: Text('작성자: ${comment['commentedBy']}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '댓글을 입력하세요...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
