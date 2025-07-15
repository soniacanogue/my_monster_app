import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no están configuradas para esta plataforma',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBjnJWxoCWv-O7P1Ai9hETssk4ZXteRlNY',
    appId: '1:34637035464:web:62510612a4af59f9a9b2fd',
    messagingSenderId: '34637035464',
    projectId: 'my-monster-app1',
    authDomain: 'my-monster-app1.firebaseapp.com',
    storageBucket: 'my-monster-app1.firebasestorage.app',
    measurementId: 'G-EK3DZ2TDGR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjnJWxoCWv-O7P1Ai9hETssk4ZXteRlNY',
    appId: '1:34637035464:web:62510612a4af59f9a9b2fd',
    messagingSenderId: '34637035464',
    projectId: 'my-monster-app1',
    storageBucket: 'my-monster-app1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjnJWxoCWv-O7P1Ai9hETssk4ZXteRlNY',
    appId: '1:34637035464:web:62510612a4af59f9a9b2fd',
    messagingSenderId: '34637035464',
    projectId: 'my-monster-app1',
    iosClientId: 'TU_IOS_CLIENT_ID', // ⚠️ Esto lo puedes dejar así si no usas iOS
    iosBundleId: 'com.tuapp.bundleid',
    storageBucket: 'my-monster-app1.firebasestorage.app',
  );
}
