import 'dart:developer';
import 'dart:io';

import 'package:blank/Model/group.dart';
import 'package:blank/widget/render_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage 패키지 추가
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  String? groupName;
  String? groupDescription;

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  // 이미지 업로드 함수
  Future<String?> _uploadImage(String groupId) async {
    if (_image == null) return null;

    try {
      // Storage에 이미지 업로드
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('group_images/$groupId'); // 그룹 ID를 기준으로 이미지 저장
      final uploadTask = storageRef.putFile(File(_image!.path));

      // 업로드 완료 후 URL 반환
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('이미지 업로드 실패: $e');
      return null;
    }
  }

  Future<void> _registerGroup(BuildContext context) async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save(); // onSaved가 호출되면서 입력값들이 저장됨

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && groupName != null && groupDescription != null) {
        // 그룹 문서 참조 생성 (자동 ID 생성)
        DocumentReference groupRef =
            FirebaseFirestore.instance.collection('groups').doc();
        String groupId = groupRef.id; // 자동 생성된 groupId 가져오기

        // 이미지 업로드
        String? imageUrl = await _uploadImage(groupId);

        // Group 객체 생성
        Group newGroup = Group(
          groupId: groupId, // 자동 생성된 groupId 사용
          groupName: groupName!, // 저장된 groupName 사용
          groupDescription: groupDescription!, // 저장된 groupDescription 사용
          mainImage: imageUrl ?? '', // 업로드된 이미지 URL 사용
          createdBy: user.uid,
          members: [
            user.uid,
          ],
          invitedUsers: [],
        );

        // Firestore에 그룹 저장
        await groupRef.set(newGroup.toFirestore());

        // 사용자 문서 참조
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // 트랜잭션을 사용하여 사용자 그룹 목록 업데이트
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot userSnapshot = await transaction.get(userRef);

          if (userSnapshot.exists) {
            List<String> updatedGroups =
                List<String>.from(userSnapshot['groups'] ?? []);
            updatedGroups.add(groupId); // 새로 생성된 그룹 ID 추가

            // 사용자 문서 업데이트
            transaction.update(userRef, {'groups': updatedGroups});
          }
        });

        // 그룹 생성 완료 후 홈 화면으로 이동
        if (context.mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(85, 137, 137, 137),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.grey.withAlpha(25)),
                image: _image != null
                    ? DecorationImage(
                        image: FileImage(File(_image!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    child: const Text("Camera")),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    child: const Text("Gallery"))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    renderTextFormField(
                      label: "그룹 이름",
                      onSaved: (val) {
                        groupName = val; // 그룹 이름 저장
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return '그룹 이름을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    renderTextFormField(
                      label: "그룹 설명",
                      onSaved: (val) {
                        groupDescription = val; // 그룹 설명 저장
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return '그룹 설명을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  _registerGroup(context);
                },
                child: const Text('생성')),
          ],
        ),
      ),
    );
  }
}
