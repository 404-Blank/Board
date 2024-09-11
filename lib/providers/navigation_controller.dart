import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier: Navigator 관련 로직을 처리
class NavigationController extends StateNotifier<void> {
  NavigationController() : super(null);

  // A 화면에서 Navigator.pushReplacement 호출
  void navigateWithReplacement(BuildContext context, Widget newScreen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => newScreen),
    );
  }
}

// StateNotifierProvider: NavigationController의 인스턴스를 제공
final navigationControllerProvider =
    StateNotifierProvider<NavigationController, void>((ref) {
  return NavigationController();
});
