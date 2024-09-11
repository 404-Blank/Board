import 'dart:developer';

import 'package:blank/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blank/Model/post.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isButtonEnabled = false;

  final DatabaseService _databaseService =
      DatabaseService(); // DatabaseService 인스턴스 생성

  @override
  void initState() {
    _titleController.addListener(_checkFieldsAreValidate);
    _contentController.addListener(_checkFieldsAreValidate);
    super.initState();
  }

  void _checkFieldsAreValidate() {
    setState(() {
      _isButtonEnabled = _titleController.text.isNotEmpty &&
          _contentController.text.isNotEmpty;
    });
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      // 게시글 데이터를 저장할 Post 객체 생성
      Post newPost = Post(
        id: '', // Firebase에서 자동 생성됨
        author: currentUser?.displayName ?? '작성자', // 실제 사용자 정보로 대체
        category: 'General', // 카테고리는 임의로 설정 (카테고리 기능을 추가할 수도 있음)
        title: _titleController.text,
        content: _contentController.text,
        createdAt: 0,
        views: 0,
        likes: 0,
      );

      // DatabaseService의 createPost 메서드 호출하여 저장
      await _databaseService.createPost(newPost);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시물이 성공적으로 등록되었습니다!')),
      );

      // 화면 닫기
      Navigator.of(context).pop();
      log('게시물이 성공적으로 등록되었습니다!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          icon: SvgPicture.asset(
            'lib/asset/icons/chevron_back.svg',
            width: 32.0, // 아이콘 크기 설정
            height: 32.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed:
                _isButtonEnabled ? _submitPost : null, // 유효성 검증에 따른 비활성화 처리
            child: Text(
              '등록',
              style: TextStyle(
                color: _isButtonEnabled
                    ? const Color(0xFF008DFF)
                    : const Color(0x33787B80),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontVariations: const [FontVariation('wght', 500)],
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  controller: _titleController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontVariations: [FontVariation('wght', 600)],
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: Color(0xFF060B11),
                  ),
                  decoration: const InputDecoration(
                    hintText: '제목 없음',
                    border: InputBorder.none,
                    counterText: '',
                    hintStyle: TextStyle(
                      fontFamily: 'Pretendard',
                      fontVariations: [FontVariation('wght', 600)],
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Color(0xFFAEAFB2),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  maxLines: null,
                  controller: _contentController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF060B11),
                    letterSpacing: -0.14,
                  ),
                  decoration: const InputDecoration(
                    hintText: '여기를 탭하여 입력을 시작하세요.',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFFAEAFB2),
                      letterSpacing: -0.14,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력하세요';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
