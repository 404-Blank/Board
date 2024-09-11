import 'package:blank/Model/post.dart';
import 'package:blank/screen/add_post_screen.dart';
import 'package:blank/screen/post_detail_screen.dart';
import 'package:blank/widget/post_item.dart';
import 'package:flutter/material.dart';
import 'package:blank/service/database_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<List<Post>>(
          stream: _databaseService.getPostsStream(), // 실시간으로 데이터 가져오기
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // 로딩 중일 때
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}')); // 에러 발생 시
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('게시글이 없습니다.')); // 데이터가 없을 때
            } else {
              // 데이터가 있을 때 게시글을 ListView로 표시
              List<Post> postList = snapshot.data!;
              return ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  return PostItem(
                    post: postList[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(postId: postList[index].id),
                        ),
                      );
                    },
                  ); // PostItem 위젯으로 각 게시글 표시
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddPostScreen()));
          },
          backgroundColor: Colors.black,
          label: const Text(
            '글쓰기',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(28.0)),
        ),
      ),
    );
  }
}
