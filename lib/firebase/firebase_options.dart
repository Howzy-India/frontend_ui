import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Replace these placeholder values by running `flutterfire configure`.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC7gWj8tS-nNhdZvyWIzbopW3yYtZlUMgI',
    appId: '1:589726044623:web:1eeecd252f81de2a8102ba',
    messagingSenderId: '589726044623',
    projectId: 'howzy-5ddd9',
    authDomain: 'howzy-5ddd9.firebaseapp.com',
    storageBucket: 'howzy-5ddd9.firebasestorage.app',
    measurementId: 'G-QLYEENRRCP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaWvVOYOCsjcvd7mKmV24izOSz5pmMuBw',
    appId: '1:589726044623:android:bfd2dc479e6bdd408102ba',
    messagingSenderId: '589726044623',
    projectId: 'howzy-5ddd9',
    storageBucket: 'howzy-5ddd9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPGAlE0wC5G8rTp3yEeS5bnmx3QjQlVe8',
    appId: '1:589726044623:ios:a2fbd330989e80aa8102ba',
    messagingSenderId: '589726044623',
    projectId: 'howzy-5ddd9',
    storageBucket: 'howzy-5ddd9.firebasestorage.app',
    iosBundleId: 'com.example.flutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPGAlE0wC5G8rTp3yEeS5bnmx3QjQlVe8',
    appId: '1:589726044623:ios:a2fbd330989e80aa8102ba',
    messagingSenderId: '589726044623',
    projectId: 'howzy-5ddd9',
    storageBucket: 'howzy-5ddd9.firebasestorage.app',
    iosBundleId: 'com.example.flutterApp',
  );

}