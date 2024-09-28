import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blank/model/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _photoURLController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // FirebaseAuth에서 현재 사용자 정보를 가져와서 초기값 설정
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _displayNameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
      _photoURLController.text = user.photoURL ?? '';
    }
  }

  Future<void> _registerUser(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // UserModel 생성
      UserModel newUser = UserModel(
        userId: user.uid,
        displayName: _displayNameController.text.trim(),
        email: _emailController.text.trim(),
        photoURL: user.photoURL,
        groups: [], // 처음에는 빈 그룹 리스트로 시작
        pendingInvitations: [], // 처음에는 빈 초대 리스트로 시작
      );

      // Firestore에 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(newUser.toFirestore());

      // 회원가입 완료 후 다음 화면으로 이동 (예: 홈 화면)
      if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                hintText: '사용자 이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: '이메일을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _photoURLController,
              decoration: const InputDecoration(
                labelText: 'Photo URL',
                hintText: '프로필 사진 URL을 입력하세요 (선택 사항)',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _registerUser(context);
              },
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
