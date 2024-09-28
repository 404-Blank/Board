import 'package:blank/Model/group.dart';
import 'package:blank/screen/add_group_screen.dart';
import 'package:blank/screen/group_detail_screen.dart';
import 'package:blank/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final FirestoreService fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('사용자 그룹 목록'),
          actions: [
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  fs.logout(context, ref);
                },
                child: const Text("로그아웃"))
          ],
        ),
        body: StreamBuilder<List<Group>>(
          // FirestoreService의 메서드를 Stream으로 변경하여 실시간 데이터 구독
          stream: fs.streamUserGroups(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('속한 그룹이 없습니다.'));
            } else {
              List<Group> groups = snapshot.data!;
              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  Group group = groups[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: group.mainImage.isNotEmpty
                          ? NetworkImage(group.mainImage)
                          : null,
                      child: group.mainImage.isEmpty
                          ? const Icon(Icons.group)
                          : null,
                    ),
                    title: Text(group.groupName),
                    subtitle: Text(group.groupDescription),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GroupDetailScreen(groupId: group.groupId),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddGroupScreen()),
            );
          },
          backgroundColor: Colors.black,
          label: const Text(
            '그룹 생성',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(28.0),
          ),
        ),
      ),
    );
  }
}
