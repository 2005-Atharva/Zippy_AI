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
        return windows;
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
    apiKey: 'AIzaSyC2sNQbaaMNNhBoDw6BPImybgyVtE7Y8Y4',
    appId: '1:1056335231213:web:a98a1adf82548ce4d2b4e4',
    messagingSenderId: '1056335231213',
    projectId: 'test7-a139a',
    authDomain: 'test7-a139a.firebaseapp.com',
    storageBucket: 'test7-a139a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDc1x-T8d10jvNS5w8sZ-TzfbEho4DYj5U',
    appId: '1:1056335231213:android:c4a82551139252e0d2b4e4',
    messagingSenderId: '1056335231213',
    projectId: 'test7-a139a',
    storageBucket: 'test7-a139a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2Y3knHP4jvmT76WlwJu7VeRxN9bRNYjc',
    appId: '1:1056335231213:ios:6d23c97f6e98fe9dd2b4e4',
    messagingSenderId: '1056335231213',
    projectId: 'test7-a139a',
    storageBucket: 'test7-a139a.appspot.com',
    iosBundleId: 'com.example.userAuthTry7',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2Y3knHP4jvmT76WlwJu7VeRxN9bRNYjc',
    appId: '1:1056335231213:ios:6d23c97f6e98fe9dd2b4e4',
    messagingSenderId: '1056335231213',
    projectId: 'test7-a139a',
    storageBucket: 'test7-a139a.appspot.com',
    iosBundleId: 'com.example.userAuthTry7',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2sNQbaaMNNhBoDw6BPImybgyVtE7Y8Y4',
    appId: '1:1056335231213:web:c23aa12478f5aaead2b4e4',
    messagingSenderId: '1056335231213',
    projectId: 'test7-a139a',
    authDomain: 'test7-a139a.firebaseapp.com',
    storageBucket: 'test7-a139a.appspot.com',
  );
}
