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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDKzokfJBvf90DCXB0OycHOa4RVJYsZ_-U',
    appId: '1:105695732948:web:f6c50458f99221216dc741',
    messagingSenderId: '105695732948',
    projectId: 'ss-sna',
    authDomain: 'ss-sna.firebaseapp.com',
    storageBucket: 'ss-sna.firebasestorage.app',
    measurementId: 'G-WCMCDKXESZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrfF1Dpc-0r1NlHjJ1kS7PZzWhOGDVwAU',
    appId: '1:105695732948:android:3ee21d5963113e206dc741',
    messagingSenderId: '105695732948',
    projectId: 'ss-sna',
    storageBucket: 'ss-sna.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDKzokfJBvf90DCXB0OycHOa4RVJYsZ_-U',
    appId: '1:105695732948:web:38a1a53f040fb30d6dc741',
    messagingSenderId: '105695732948',
    projectId: 'ss-sna',
    authDomain: 'ss-sna.firebaseapp.com',
    storageBucket: 'ss-sna.firebasestorage.app',
    measurementId: 'G-TMSYX16EGD',
  );
}
