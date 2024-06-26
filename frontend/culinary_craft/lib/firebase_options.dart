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
    apiKey: 'AIzaSyBlJ7VMiIyne30_afsTuVSZ9PakQkis8oE',
    appId: '1:591392172427:web:5cabdced7006330c64278e',
    messagingSenderId: '591392172427',
    projectId: 'culinarycraft-10c08',
    authDomain: 'culinarycraft-10c08.firebaseapp.com',
    storageBucket: 'culinarycraft-10c08.appspot.com',
    measurementId: 'G-NMCQKWR3EF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVqOTtiPFKyIQFluL3js4zbfs-nSl_QvE',
    appId: '1:591392172427:android:998d3faa8b15303564278e',
    messagingSenderId: '591392172427',
    projectId: 'culinarycraft-10c08',
    storageBucket: 'culinarycraft-10c08.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwbr0AJjBs1uMM7E2VooUfR91dgcqPGbw',
    appId: '1:591392172427:ios:6b36e9ba8637ebe464278e',
    messagingSenderId: '591392172427',
    projectId: 'culinarycraft-10c08',
    storageBucket: 'culinarycraft-10c08.appspot.com',
    iosClientId: '591392172427-oopoi3l3j3fslu3cep41arle4d8p95sc.apps.googleusercontent.com',
    iosBundleId: 'com.example.culinaryCraft',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwbr0AJjBs1uMM7E2VooUfR91dgcqPGbw',
    appId: '1:591392172427:ios:981edbae34e384fa64278e',
    messagingSenderId: '591392172427',
    projectId: 'culinarycraft-10c08',
    storageBucket: 'culinarycraft-10c08.appspot.com',
    iosClientId: '591392172427-1tn6r191ksl4dp85ag5gcs9ma4g52umj.apps.googleusercontent.com',
    iosBundleId: 'com.example.culinaryCraft.RunnerTests',
  );
}
