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
    apiKey: 'AIzaSyAWcJY_w8WMd_FO14hfsA1--JhlBXfSh8o',
    appId: '1:506217656142:web:0bdc409a70cc2525b6f81f',
    messagingSenderId: '506217656142',
    projectId: 'cmsapp-1f6c5',
    authDomain: 'cmsapp-1f6c5.firebaseapp.com',
    storageBucket: 'cmsapp-1f6c5.appspot.com',
    measurementId: 'G-DNWJ4FN9QB',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcMmB79Xso8KMWi0JVZ0_Jg-O5dCtwFHY',
    appId: '1:506217656142:ios:b776086928a35cc0b6f81f',
    messagingSenderId: '506217656142',
    projectId: 'cmsapp-1f6c5',
    storageBucket: 'cmsapp-1f6c5.appspot.com',
    iosBundleId: 'com.example.appCmsGhc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcMmB79Xso8KMWi0JVZ0_Jg-O5dCtwFHY',
    appId: '1:506217656142:ios:b776086928a35cc0b6f81f',
    messagingSenderId: '506217656142',
    projectId: 'cmsapp-1f6c5',
    storageBucket: 'cmsapp-1f6c5.appspot.com',
    iosBundleId: 'com.example.appCmsGhc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAWcJY_w8WMd_FO14hfsA1--JhlBXfSh8o',
    appId: '1:506217656142:web:92165322eb496f27b6f81f',
    messagingSenderId: '506217656142',
    projectId: 'cmsapp-1f6c5',
    authDomain: 'cmsapp-1f6c5.firebaseapp.com',
    storageBucket: 'cmsapp-1f6c5.appspot.com',
    measurementId: 'G-JHSRYT5CE3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYrb-MQ1Ej98SU-jQ3-8w3oyJHzNsx4qA',
    appId: '1:506217656142:android:0f7d1e7e5dd04c2db6f81f',
    messagingSenderId: '506217656142',
    projectId: 'cmsapp-1f6c5',
    storageBucket: 'cmsapp-1f6c5.appspot.com',
  );

}