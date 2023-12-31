// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyCv9QaiGfBebDdHdlqHaOtHSgI8ghqoFJE',
    appId: '1:229066764747:web:0a59044684fdf43fc9c64e',
    messagingSenderId: '229066764747',
    projectId: 'test-a1a80',
    authDomain: 'test-a1a80.firebaseapp.com',
    storageBucket: 'test-a1a80.appspot.com',
    measurementId: 'G-H2RDVF27N8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEKYQ7qVMEZHJwiTL0D4vKxDUZgqZdwfM',
    appId: '1:229066764747:android:65c575255550130ac9c64e',
    messagingSenderId: '229066764747',
    projectId: 'test-a1a80',
    storageBucket: 'test-a1a80.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCu5M5yyEGtG7-vD8pyaWmo212zbHsdfeM',
    appId: '1:229066764747:ios:7de58d641e38e668c9c64e',
    messagingSenderId: '229066764747',
    projectId: 'test-a1a80',
    storageBucket: 'test-a1a80.appspot.com',
    iosBundleId: 'com.example.miniProjet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCu5M5yyEGtG7-vD8pyaWmo212zbHsdfeM',
    appId: '1:229066764747:ios:76c3d8d4332b8c4fc9c64e',
    messagingSenderId: '229066764747',
    projectId: 'test-a1a80',
    storageBucket: 'test-a1a80.appspot.com',
    iosBundleId: 'com.example.miniProjet.RunnerTests',
  );
}
