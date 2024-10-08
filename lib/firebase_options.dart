// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC-TfmS_yMSOegaeJVRuXdSLYQGqdgHm8A',
    appId: '1:91864602031:web:0e1a4b2b9817f91db64b5a',
    messagingSenderId: '91864602031',
    projectId: 'blank-a20ed',
    authDomain: 'blank-a20ed.firebaseapp.com',
    storageBucket: 'blank-a20ed.appspot.com',
    measurementId: 'G-W1KLNJHCQJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDveigYA2KOGCs-lei_7AN6H23Ojg3iZBU',
    appId: '1:91864602031:android:3c085d9368085a79b64b5a',
    messagingSenderId: '91864602031',
    projectId: 'blank-a20ed',
    storageBucket: 'blank-a20ed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIdG7nPIXIrYjmRgJZ3-XP4rKgblVptq4',
    appId: '1:91864602031:ios:2aa62b951704c1c8b64b5a',
    messagingSenderId: '91864602031',
    projectId: 'blank-a20ed',
    storageBucket: 'blank-a20ed.appspot.com',
    iosBundleId: 'com.example.blank',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIdG7nPIXIrYjmRgJZ3-XP4rKgblVptq4',
    appId: '1:91864602031:ios:2aa62b951704c1c8b64b5a',
    messagingSenderId: '91864602031',
    projectId: 'blank-a20ed',
    storageBucket: 'blank-a20ed.appspot.com',
    iosBundleId: 'com.example.blank',
  );
}
