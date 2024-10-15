

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:maru/main.dart';


Future<void> handleBackGroundNotification(RemoteMessage? remoteMessage) async{
  if(remoteMessage == null) return;

  // push notification
  // navigatorKey.currentState?.pushNamed("/admin_inquiries");

  // get to know which client was sent a message
  print("Title : ${remoteMessage.notification?.title}");
  print("Body : ${remoteMessage.notification?.body}");
  print("Payload : ${remoteMessage.data}");
}

class PushNotificationApi{
  final firebaseMessaging = FirebaseMessaging.instance;
  // initialize the notification
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();

    // always save the fCMToken to the database
    print(fCMToken);
    FirebaseMessaging.onBackgroundMessage(handleBackGroundNotification);
  }
}