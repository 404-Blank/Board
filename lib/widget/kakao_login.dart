import 'package:blank/service/kakao_login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KakaoLogin extends ConsumerWidget {
  const KakaoLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 62),
                backgroundColor: const Color(0xFFFEE500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await KakaoLoginService.kakaoLogin(ref);
              },
              icon: SvgPicture.asset('lib/asset/logo/kakao_logo.svg'),
              label: const Text(
                '카카오로 시작하기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Pretendard',
                  fontVariations: [FontVariation('wght', 600)],
                  height: 0.08,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
