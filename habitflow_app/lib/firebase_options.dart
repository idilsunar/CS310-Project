import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDIPHzdORoB53tclffdo4NO1ZHT-eAuaGc',
    appId: '1:638140953956:web:0ad6a392c44b5f9fdb3671',
    messagingSenderId: '638140953956',
    projectId: 'habitflow-106cd',
    authDomain: 'habitflow-106cd.firebaseapp.com',
    storageBucket: 'habitflow-106cd.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIPHzdORoB53tclffdo4NO1ZHT-eAuaGc',
    appId: '1:638140953956:android:0ad6a392c44b5f9fdb3671',
    messagingSenderId: '638140953956',
    projectId: 'habitflow-106cd',
    storageBucket: 'habitflow-106cd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAD1xuXqntge01bwnPWNVbKGEznNKjQAqk',
    appId: '1:638140953956:ios:fab8b6ed51aaddafdb3671',
    messagingSenderId: '638140953956',
    projectId: 'habitflow-106cd',
    storageBucket: 'habitflow-106cd.firebasestorage.app',
    iosBundleId: 'com.example.habitflowApp',
  );
}

