import 'package:blank/screen/login_screen.dart';
import 'package:blank/screen/tabs.dart';
import 'package:blank/service/firestore_service.dart';
import 'package:blank/service/invitation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInvitationScreen extends StatelessWidget {
  final String groupId;

  const GroupInvitationScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    FirestoreService fs = FirestoreService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('초대'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('groups').doc(groupId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Group not found.'));
          } else {
            var groupData = snapshot.data!.data() as Map<String, dynamic>;
            String? groupName = groupData['groupName'];
            String? mainImage = groupData['mainImage'];
            List<String> members =
                List<String>.from(groupData['members'] ?? []);

            User? user = FirebaseAuth.instance.currentUser;
            bool isMember = user != null && members.contains(user.uid);

            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (mainImage != null && mainImage.isNotEmpty)
                    ClipOval(
                      child: Image.network(
                        mainImage,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text('아래 그룹에 초대 되었습니다!'),
                  Text(
                    groupName ?? 'Group Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isMember)
                    ElevatedButton(
                      onPressed: () async {
                        if (user != null) {
                          await fs.addUserToGroup(user, groupId);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => TabsScreen(
                                  invitationService: InvitationService()),
                            ),
                            (Route<dynamic> route) => false, // 모든 이전 화면 제거
                          );
                        } else {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (Route<dynamic> route) => false, // 모든 이전 화면 제거
                          );
                        }
                      },
                      child: const Text('Join Group'),
                    ),
                  if (isMember)
                    const Text(
                      '이미 속해 있는 그룹입니다.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
