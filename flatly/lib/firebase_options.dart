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
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAyRNfdEwKzncBctjrRR2tTcf7LXT6P8',
    appId: '1:888747171791:web:15c48cc517040062af3cba',
    messagingSenderId: '888747171791',
    projectId: 'flutter-chat-pca',
    authDomain: 'flutter-chat-pca.firebaseapp.com',
    storageBucket: 'flutter-chat-pca.firebasestorage.app',
    measurementId: 'G-QSYTH717VG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyRNfdEwKzncBctjrRR2tTcf7LXT6P8', // Usamos la misma Key del proyecto
    appId: '1:888747171791:android:3461e7d737c01be4af3cba', // Tu nueva ID Android
    messagingSenderId: '888747171791',
    projectId: 'flutter-chat-pca',
    storageBucket: 'flutter-chat-pca.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyRNfdEwKzncBctjrRR2tTcf7LXT6P8',
    appId: '1:888747171791:ios:555779ac616682bdaf3cba', // Tu nueva ID iOS
    messagingSenderId: '888747171791',
    projectId: 'flutter-chat-pca',
    storageBucket: 'flutter-chat-pca.firebasestorage.app',
    iosBundleId: 'com.example.flatly',
  );
}