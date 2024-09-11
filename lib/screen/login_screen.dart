import 'package:blank/screen/add_post_screen.dart';
import 'package:blank/screen/main_screen.dart';
import 'package:blank/screen/tabs.dart';
import 'package:blank/widget/kakao_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 200,
                        height: 200,
                        child: SvgPicture.asset(
                          'lib/asset/logo/logo.svg',
                        )),
                    const SizedBox(
                      width: 136,
                      child: Text(
                        '쌓이면 \n뭐든 된다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: 'Pretendard',
                          fontVariations: [FontVariation('wght', 700)],
                          // fontWeight: FontWeight.w700,
                          letterSpacing: -0.96,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const KakaoLogin(
                mainScreen: TabsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
