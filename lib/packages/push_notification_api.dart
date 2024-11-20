

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:maru/main.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';


Future<void> handleBackGroundNotification(RemoteMessage? remoteMessage) async{
  if(remoteMessage == null) return;

  // push notification
  String user_type = remoteMessage.data['user_type'].toString() ?? "0";
  print("User type : ${user_type}");
  if(user_type == "2"){
    navigatorKey.currentState?.pushNamed("/admin_dashboard", arguments: {"index": 3});
  }else if(user_type == "3"){
    navigatorKey.currentState?.pushNamed("/super_admin_dashboard", arguments: {"index": 3});
  }else if(user_type == "4"){
    navigatorKey.currentState?.pushNamed("/member_dashboard", arguments: {"index": 2});
  }else{
    navigatorKey.currentState?.pushNamed("/");
  }

  // get to know which client was sent a message
  print("Title : ${remoteMessage.notification?.title}");
  print("Body : ${remoteMessage.notification?.body}");
  print("Payload : ${remoteMessage.data}");
  print("Send to : ${remoteMessage.data['send_to']}");
  print("User type : ${remoteMessage.data['user_type']}");
}

class PushNotificationApi{
  final firebaseMessaging = FirebaseMessaging.instance;
  static RemoteMessage? _remoteMsg;

  static RemoteMessage? get remoteMsg => _remoteMsg;

  static void setRemoteMsg(RemoteMessage? message) {
    _remoteMsg = message;
  }

  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse)async {
    handleBackGroundNotification(remoteMsg);
  }

  // initialize the notification
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    // check if this user has an FCM TOKEN AND UPDATE IT AFTER 5 DAYS IF EXPIRED
    ApiConnection apiConnection = new ApiConnection();
    CustomThemes customThemes = new CustomThemes();
    var response = await apiConnection.checkMemberFCM();
    print("FCM TOKEN : $response");
    bool getFCMToken = false;
    if(customThemes.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        getFCMToken = res['update_fcm'];
      }
    }
    if(getFCMToken){
      final fCMToken = await firebaseMessaging.getToken();
      var response = await apiConnection.updateMemberFCM(fCMToken!);
    }

    // initialize push notification
    await initPushNotifications();
    await initLocalNotification();
  }

 static Future<void> initLocalNotification() async{
    try{
      const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("ic_launcher");
      const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings();
      const InitializationSettings initializationSettings = InitializationSettings(
          android: androidInitializationSettings,
          iOS: darwinInitializationSettings
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
      );
      await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }catch(e){
      print("Error:  $e");
    }
  }

  Future<void> showInstantNotification(String title, String body)async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.high,
        priority: Priority.high,
        icon: 'ic_launcher',
        playSound: true,
        // largeIcon: const DrawableResourceAndroidBitmap('ic_launcher')
      ),
      iOS: DarwinNotificationDetails()
    );

    await _localNotifications.show(0, title, body, platformChannelSpecifics);
  }

  Future<void> initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleBackGroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackGroundNotification);
    FirebaseMessaging.onBackgroundMessage(handleBackGroundNotification);

    // handles foreground notifications
    FirebaseMessaging.onMessage.listen((message){
      final notifications = message.notification;
      if(notifications == null) return;
      handleForeGroundNotification(message);
    });
  }

  Future<void> handleForeGroundNotification(RemoteMessage? remoteMessage) async{
    if(remoteMessage == null) return;
    // get to know which client was sent a message
    setRemoteMsg(remoteMessage);
    showInstantNotification(remoteMessage.notification!.title.toString(), remoteMessage.notification!.body.toString());
  }
}