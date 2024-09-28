import 'dart:developer';

import 'package:blank/Model/group.dart';
import 'package:blank/providers/kakao_login_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 로그인 후, Firestore에서 사용자 문서를 확인하는 함수
  Future<void> checkUserAndNavigate(BuildContext context) async {
    User? user = _auth.currentUser; // 현재 로그인된 사용자 정보 가져오기
    if (user != null) {
      String userUID = user.uid; // 사용자 UID

      // Firestore에서 해당 UID로 문서가 있는지 확인
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userUID).get();

      // 현재 위젯이 화면에 여전히 존재하는지 확인
      if (!context.mounted) return;

      if (userDoc.exists) {
        // 문서가 있으면 홈 페이지나 다른 페이지로 이동
        Navigator.pushReplacementNamed(context, '/home'); // 홈 페이지로 이동
      } else {
        // 문서가 없으면 사용자 생성 페이지로 이동
        Navigator.pushReplacementNamed(
            context, '/createUser'); // 사용자 생성 페이지로 이동
      }
    } else {
      // 로그인되지 않은 경우 로그인 페이지로 이동
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // 사용자가 속한 그룹 ID 목록을 가져오는 메서드
  Future<List<String>> getUserGroups() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        List<String> userGroups =
            List<String>.from(userSnapshot['groups'] ?? []);
        return userGroups;
      }
    }
    return [];
  }

  // 특정 그룹 ID 목록에 해당하는 그룹 정보를 가져오는 메서드
  Future<List<Group>> getGroups(List<String> groupIds) async {
    List<Group> groups = [];

    for (String groupId in groupIds) {
      DocumentSnapshot groupSnapshot =
          await _firestore.collection('groups').doc(groupId).get();

      if (groupSnapshot.exists) {
        groups.add(Group.fromFirestore(
            groupSnapshot.data() as Map<String, dynamic>, groupSnapshot.id));
      }
    }

    return groups;
  }

  Future<void> addUserToGroup(User user, String groupId) async {
    DocumentReference groupRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    DocumentSnapshot groupDoc = await groupRef.get();

    if (groupDoc.exists) {
      List<String> members = List<String>.from(groupDoc['members']);
      if (!members.contains(user.uid)) {
        await groupRef.update({
          'members': FieldValue.arrayUnion([user.uid])
        });
      }
    }

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
  }

  // 사용자가 속한 그룹을 실시간으로 구독하는 메서드
  Stream<List<Group>> streamUserGroups() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firestore
          .collection('groups')
          .where('members', arrayContains: user.uid) // 사용자가 속한 그룹을 구독
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Group.fromFirestore(doc.data(), doc.id))
              .toList());
    } else {
      // 만약 사용자가 로그인되어 있지 않으면 빈 스트림 반환
      return Stream.value([]);
    }
  }

  // Firebase 로그아웃과 상태 업데이트를 한 번에 처리하는 메서드
  Future<void> logout(BuildContext context, WidgetRef ref) async {
    try {
      // Firebase 인증 로그아웃
      await FirebaseAuth.instance.signOut();

      // Riverpod 상태를 로그아웃 상태로 변경
      ref.read(kakaoLoginProvider.notifier).logout();

      // 로그아웃 후 로그인 화면 또는 다른 화면으로 이동
      checkUserAndNavigate(context);
    } catch (e) {
      log('로그아웃 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃에 실패했습니다: $e')),
      );
    }
  }
}
