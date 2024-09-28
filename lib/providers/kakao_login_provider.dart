import 'package:flutter_riverpod/flutter_riverpod.dart';

// 로그인 상태를 관리하는 Provider
final kakaoLoginProvider =
    StateNotifierProvider<KakaoLoginNotifier, bool>((ref) {
  return KakaoLoginNotifier();
});

class KakaoLoginNotifier extends StateNotifier<bool> {
  KakaoLoginNotifier() : super(false); // 기본적으로 로그아웃 상태

  // 로그인 성공 시 상태를 true로 변경
  void loginSuccess() {
    state = true;
  }

  // 로그아웃 상태로 변경
  void logout() {
    state = false;
  }
}
