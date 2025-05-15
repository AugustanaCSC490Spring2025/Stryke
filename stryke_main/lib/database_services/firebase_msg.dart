import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await msgService.requestPermission();

    var token = await msgService.getToken();

    // Save token for user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }

    FirebaseMessaging.onBackgroundMessage(handleNotification);
    FirebaseMessaging.onMessage.listen(handleNotification);
  }
}

Future<void> handleNotification(RemoteMessage msg) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final data = msg.notification;
  if (data == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('notifications')
      .add({
    'title': data.title ?? 'No Title',
    'body': data.body ?? 'No Body',
    'timestamp': Timestamp.now(),
    'isRead': false,
  });
}
