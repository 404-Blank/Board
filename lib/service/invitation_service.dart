import 'dart:developer';

import 'package:blank/screen/group_invitation_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';

class InvitationService {
  // 초대 링크 생성

  void inviteToGroup(String groupId) async {
    InvitationService invitationService = InvitationService();
    try {
      String dynamicLink = invitationService.generateInviteLink(groupId);
      Share.share(dynamicLink);
      // Dynamic Link를 사용자와 공유하는 로직을 추가
    } catch (e) {
      log("Dynamic Link Error, $e");
    }
  }

  String generateInviteLink(String groupId) {
    return 'https://blank-a20ed.firebaseapp.com/invite?groupId=$groupId';
  }

  // 초대 링크 처리
  void handleInvitations(BuildContext context) {
    getInitialUri().then((uri) {
      if (uri != null) {
        if (context.mounted) {
          _processUri(uri, context);
        }
      }
    });

    uriLinkStream.listen((uri) {
      if (uri != null) {
        if (context.mounted) {
          _processUri(uri, context);
        }
      }
    });
  }

  // URI 처리
  void _processUri(Uri uri, BuildContext context) async {
    if (uri.path == '/invite') {
      String? groupId = uri.queryParameters['groupId'];
      if (groupId != null) {
        // Navigator 호출이 안전하게 이루어지도록 처리
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            _navigateToInvitationPage(context, groupId);
          }
        });
      } else {
        log('Group ID not found in the link');
      }
    } else {
      log('Invalid link path: ${uri.path}');
    }
  }

  // 초대 확인 페이지로 이동
  void _navigateToInvitationPage(BuildContext context, String groupId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupInvitationScreen(groupId: groupId),
      ),
    );
  }
}
