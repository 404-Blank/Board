import 'package:blank/screen/login_screen.dart';
import 'package:blank/screen/register_screen.dart';
import 'package:blank/screen/tabs.dart';
import 'package:blank/service/invitation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KakaoSdk.init(
    nativeAppKey: 'cd0a89a8107e5e79bb0ff4f9df8d4de2',
    javaScriptAppKey: '24258be1d9e5e85acb08b4353ea1251d',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final InvitationService _invitationService = InvitationService();
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoggedIn = user != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return ProviderScope(
      child: MaterialApp(
        routes: {
          '/home': (context) =>
              TabsScreen(invitationService: _invitationService),
          '/createUser': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
        },
        debugShowCheckedModeBanner: false,
        home: _isLoggedIn
            ? TabsScreen(invitationService: _invitationService)
            : const LoginScreen(),
      ),
    );
  }
}
