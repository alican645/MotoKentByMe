import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/models/location_model.dart';
import 'package:moto_kent/router.dart';
import 'package:go_router/go_router.dart';

class FirebaseNotificationService {
  late final FirebaseMessaging messaging;
  late final String? _deviceToken;

  String? get deviceToken => _deviceToken;

  // Flutter Local Notifications Plugin'in global instance'ı
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Bildirim kurulumu
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // smallIcon tanımı

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        log(response.payload!, name: "payload");
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
          _handlePayload(payloadMap);
        }
      },
    );
  }

  // Firebase Messaging ile bağlantı
  Future<void> connectNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    // Bildirim izinlerini ayarla
    await messaging.requestPermission(sound: true, alert: true, badge: true);

    // Foreground bildirim ayarları
    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    // Local Notification'ı başlat
    await initializeNotifications();

    // Foreground mesajları dinle
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("Gelen bildirim başlığı: ${event.notification?.title}");

      // Data alanını işle
      final data = event.data;
      print("Gelen Data: $data");

      // Bildirim göster
      await flutterLocalNotificationsPlugin.show(
        0, // Bildirim ID'si
        event.notification?.title ?? "Başlık Yok",
        event.notification?.body ?? "İçerik Yok",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Kanal ID
            'High Importance Notifications', // Kanal Adı
            channelDescription: 'Bu kanal önemli bildirimler içindir',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        payload: jsonEncode(event.data), // Payload olarak data'ları ekle
      );
    });

    // FCM Token al
    messaging.getToken().then((value) {
      _deviceToken = value;
      print('Firebase Messaging Token: $value');
    });
  }

  // Background mesajları işleme
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  // Data alanını işle (payload)
  void _handlePayload(Map<String, String> payload) async {
    //final Uri googleMapsUrl = Uri.parse(
    //    "https://www.google.com/maps/search/?api=1&query=${payload['latitude']},${payload['longitude']}");

    //if (await canLaunchUrl(googleMapsUrl)) {
    //  await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    //} else {
    //  print("Google Haritalar açılamadı.");
    if (payload["notificationType"] ==
        NotificationTypeEnum.callForHelp.index.toString()) {
      var locationModel = LocationModel(
          latitude: double.tryParse(payload["latitude"].toString()),
          longitude: double.tryParse(payload["longitude"].toString()),
          markerId: payload["markerId"],
          iconPath: payload["iconPath"]);
      Map<String, dynamic> data = {
        "route": payload["route"]!,
        "locationModel": locationModel
      };
      if (routerKey.currentContext != null) {
        GoRouter.of(routerKey.currentContext!)
            .go(payload["route"]!, extra: locationModel);
      } else {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (routerKey.currentContext != null) {
            GoRouter.of(routerKey.currentContext!)
                .go(AppRoutes.splashScreen, extra: data);
          }
        });
      }
    } else if (payload["notificationType"] ==
        NotificationTypeEnum.privateMessage.index.toString()) {
      var userId = payload["userId"];
      var connectionId = payload["connectionId"];
      var privateConversationId =
          int.tryParse(payload["privateConversationId"].toString());
      final Map<String, dynamic> args = {
        "userId": userId,
        "connectionId": connectionId,
        "privateConversationId": privateConversationId
      };
      if (routerKey.currentContext != null) {
        GoRouter.of(routerKey.currentContext!).push(
            '${AppRoutes.explorePage}/${AppRoutes.myPrivateMessagesPage}/${AppRoutes.privateChatPage}',
            extra: args);
      } else {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (routerKey.currentContext != null) {
            GoRouter.of(routerKey.currentContext!).push(
                '${AppRoutes.explorePage}/${AppRoutes.myPrivateMessagesPage}/${AppRoutes.privateChatPage}',
                extra: args);
          }
        });
      }
    }
  }
}
