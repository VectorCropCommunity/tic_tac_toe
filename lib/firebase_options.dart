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
    apiKey: 'AIzaSyA3aOjQpdDF8SOpuN1dn6C0SonJnZI1_jw',
    appId: '1:908960020666:web:ab39a71443688ae1f1aa83',
    messagingSenderId: '908960020666',
    projectId: 'test-505d4',
    authDomain: 'test-505d4.firebaseapp.com',
    databaseURL: 'https://test-505d4-default-rtdb.firebaseio.com',
    storageBucket: 'test-505d4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaISjMFCiLYR5SJhMrhv-BW7KxhSfu98s',
    appId: '1:908960020666:android:0ffc334551616b59f1aa83',
    messagingSenderId: '908960020666',
    projectId: 'test-505d4',
    databaseURL: 'https://test-505d4-default-rtdb.firebaseio.com',
    storageBucket: 'test-505d4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0uUf0m9HDNUT5z0zjaWdF337lAHptLkQ',
    appId: '1:908960020666:ios:f6fa9edd57bcdaddf1aa83',
    messagingSenderId: '908960020666',
    projectId: 'test-505d4',
    databaseURL: 'https://test-505d4-default-rtdb.firebaseio.com',
    storageBucket: 'test-505d4.appspot.com',
    iosBundleId: 'com.vectorcrop.ticTacToe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0uUf0m9HDNUT5z0zjaWdF337lAHptLkQ',
    appId: '1:908960020666:ios:f6fa9edd57bcdaddf1aa83',
    messagingSenderId: '908960020666',
    projectId: 'test-505d4',
    databaseURL: 'https://test-505d4-default-rtdb.firebaseio.com',
    storageBucket: 'test-505d4.appspot.com',
    iosBundleId: 'com.vectorcrop.ticTacToe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA3aOjQpdDF8SOpuN1dn6C0SonJnZI1_jw',
    appId: '1:908960020666:web:7db6fb6008554f8bf1aa83',
    messagingSenderId: '908960020666',
    projectId: 'test-505d4',
    authDomain: 'test-505d4.firebaseapp.com',
    databaseURL: 'https://test-505d4-default-rtdb.firebaseio.com',
    storageBucket: 'test-505d4.appspot.com',
  );
}
