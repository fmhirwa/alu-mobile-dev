// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
   
    return FirebaseOptions(
      apiKey: 'AIzaSyAKWy9DjKGtroA-NMOKtLH65eDoDry0Dx4',
      authDomain: 'your-auth-domain',
      projectId: 'safe-move-53af7',
      storageBucket: 'safe-move-53af7.appspot.com',
      messagingSenderId: 'your-messaging-sender-id',
      appId: '1:1020014988960:android:277b4ecc09b0cd50b7c3c5',
      measurementId: 'your-measurement-id'
    );
  }
}
