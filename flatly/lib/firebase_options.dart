// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCktHOwcy-o_mJB-XdphrP3hnD85e7AXpU',
    appId: '1:888747171791:web:2a0e738a8fbcf3f2af3cba',
    messagingSenderId: '888747171791',
    projectId: 'flutter-chat-pca',
    authDomain: 'flutter-chat-pca.firebaseapp.com',
    storageBucket: 'flutter-chat-pca.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'AIzaSyDUS17Qq4gmndhlWGxIxFZBsow5bPsK374', // De la captura del plist
    appId:
        '1:888747171791:android:5911ed9c1b89f67baf3cba', // De la captura de Android
    messagingSenderId: '888747171791',
    projectId: 'flutter-chat-pca',
    storageBucket: 'flutter-chat-pca.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey:
        'AIzaSyDUS17Qq4gmndhlWGxIxFZBsow5bPsK374', // De la captura del plist
    appId: '1:888747171791:ios:cb5a5c0427b7795daf3cba', // De la captura de iOS
    messagingSenderId: '888747171791',
    projectId: 'flutter-chat-pca',
    storageBucket: 'flutter-chat-pca.firebasestorage.app',
    iosBundleId: 'com.example.flutterChatApp', // De la captura de iOS
  );
}
