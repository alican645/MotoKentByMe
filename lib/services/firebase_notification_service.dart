import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/router.dart';
import 'package:go_router/go_router.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final String? _deviceToken;

  String? get deviceToken => _deviceToken;
  // Flutter Local Notifications Plugin'in global instance'ı

  // Background mesajları işleme
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  // Firebase Messaging ile bağlantı
  Future<void> init(BuildContext context) async {
    // Firebase Cloud Messaging izinlerini ayarlama
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Kullanıcı bildirim izni verdi');

      // Uygulama açıkken gelen bildirimleri dinleme
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        debugPrint(
            'Uygulama açıkken bildirim geldi: ${message.notification?.title}');
        _handleForegroundMessage(context, message);
      });

      // Arka planda gelen bildirimleri işleme
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Bildirime tıklandı: ${message.notification?.title}');
        //_navigateToSpecificPage(context, message);
      });

      // Yerel bildirimleri başlatma

      _initLocalNotifications(context);
    } else {
      print('Kullanıcı bildirim izni vermedi');
    }

    // FCM Token al
    _firebaseMessaging.getToken().then((value) {
      _deviceToken = value;
      print('Firebase Messaging Token: $value');
    });
  }

  // Bildirim kurulumu
  Future<void> _initLocalNotifications(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint(
          response.payload!,
        );
        // Bildirime tıklandığında çalışacak
        if (response.payload != null) {
          String fixedJson = response.payload!.replaceAllMapped(
              RegExp(r'(\s*)\."(\w+)"'), (match) => ', "${match[2]}"');

          // JSON string'ini Map<String, dynamic> olarak decode et
          var decodedMap = jsonDecode(fixedJson) as Map<String, dynamic>;

          // Map<String, dynamic>'i Map<String, String>'e dönüştür
          Map<String, String> payloadMap = decodedMap.map(
            (key, value) => MapEntry(key, value.toString()),
          );
          _handlePayload(payloadMap, context);
        }
      },
    );
  }

  // Data alanını işle (payload)
  void _handlePayload(Map<String, String> payload, BuildContext context) async {
    if (payload["notificationType"] ==
        NotificationTypeEnum.callForHelp.index.toString()) {
      var locationModel = LocationModel(
          latitude: double.tryParse(payload["latitude"].toString()),
          longitude: double.tryParse(payload["longitude"].toString()),
          markerId: payload["markerId"],
          iconPath: payload["iconPath"]);
      Map<String, dynamic> arg = {
        "callForHelpLatLangModel": locationModel,
        "notificationType": payload["notificationType"],
      };
      if (routerKey.currentContext != null) {
        final isBackground = <String, dynamic>{"isBackground": false};
        arg.addEntries(isBackground.entries);
        GoRouter.of(routerKey.currentContext!)
            .go(AppRoutes.splashScreen, extra: arg);
      } else {
        final isBackground = <String, dynamic>{"isBackground": true};
        arg.addEntries(isBackground.entries);
        GoRouter.of(context).go(AppRoutes.splashScreen, extra: arg);
      }

      //private message
    } else if (payload["notificationType"] ==
        NotificationTypeEnum.privateMessage.index.toString()) {
      var userId = payload["userId"];
      var connectionId = payload["connectionId"];
      var privateConversationId =
          int.tryParse(payload["privateConversationId"].toString());
      final Map<String, dynamic> args = {
        "notificationType": payload["notificationType"],
        "userId": userId,
        "connectionId": connectionId,
        "privateConversationId": privateConversationId
      };
      if (routerKey.currentContext != null) {
        final isBackground = <String, dynamic>{"isBackground": false};
        args.addEntries(isBackground.entries);
        GoRouter.of(routerKey.currentContext!)
            .go(AppRoutes.splashScreen, extra: args);
      } else {
        debugPrint("context verilmeden öncesi");
        final isBackground = <String, dynamic>{"isBackground": true};
        args.addEntries(isBackground.entries);
        GoRouter.of(context).go(AppRoutes.splashScreen, extra: args);
        debugPrint("context verilmeden sonrası");
      }
    } else if (payload["notificationType"] ==
        NotificationTypeEnum.groupChatMessage.index.toString()) {
      final Map<String, dynamic> args = {
        "notificationType": payload["notificationType"],
        "userId": payload["userId"],
        "groupId": int.tryParse(payload["groupId"].toString()),
        "userName": payload["userName"],
        "groupName": payload["groupName"]
      };
      if (routerKey.currentContext != null) {
        final isBackground = <String, dynamic>{"isBackground": false};
        args.addEntries(isBackground.entries);
        GoRouter.of(routerKey.currentContext!)
            .go(AppRoutes.splashScreen, extra: args);
      } else {
        debugPrint("context verilmeden öncesi");
        final isBackground = <String, dynamic>{"isBackground": true};
        args.addEntries(isBackground.entries);
        GoRouter.of(context).go(AppRoutes.splashScreen, extra: args);
        debugPrint("context verilmeden sonrası");
      }
    }
  }

  // Ön planda gelen bildirimleri işleme
  void _handleForegroundMessage(BuildContext context, RemoteMessage message) {
    // Yerel bildirim gösterme
    _showLocalNotification(
      title: message.notification?.title ?? 'Bildirim',
      body: message.notification?.body ?? 'Yeni bir bildiriminiz var',
      payload: jsonEncode(message.data),
    );
  }

  // Yerel bildirim gösterme
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'high_importance_channel', // Kanal ID
            'High Importance Notifications', // Kanal Adı
            channelDescription: 'Bu kanal önemli bildirimler içindir',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
