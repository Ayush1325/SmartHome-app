import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  FirebaseMessaging _firebaseMessaging;
  Firestore _firestore;

  FirebaseHelper() {
    this._firebaseMessaging = FirebaseMessaging();
    this._firestore = Firestore.instance;
    firebaseMessagingListeners();
    _firebaseMessaging.onTokenRefresh.listen((token) {
      final DocumentReference doc = _firestore.collection('client').document("ayushsingh1325@gmail.com");
      Firestore.instance.runTransaction((transaction) async {
        final freshSnap = await transaction.get(doc);
        if (freshSnap.exists) {
          await transaction.update(doc, {'msgToken': token});
        }
      });
    });
  }

  void firebaseMessagingListeners() {
    _firebaseMessaging.getToken();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
}