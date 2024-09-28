import 'dart:developer';
import 'package:blank/providers/kakao_login_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KakaoLoginService {
  static Future<void> kakaoLogin(WidgetRef ref) async {
    final provider = OAuthProvider("oidc.blank");
    OAuthToken? token;

    try {
      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          log('카카오톡으로 로그인 성공');
        } catch (error) {
          log('카카오톡으로 로그인 실패 $error');
          if (error is PlatformException && error.code == 'CANCELED') {
            log('사용자가 로그인 취소');
            return;
          }
          token = await UserApi.instance.loginWithKakaoAccount();
          log('카카오계정으로 로그인 성공');
        }
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        log('카카오계정으로 로그인 성공');
      }

      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 로그인 성공 시 상태를 업데이트
      ref.read(kakaoLoginProvider.notifier).loginSuccess();
    } catch (e) {
      log(await KakaoSdk.origin);
      log('로그인 실패: $e');
    }
  }
}
