import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  late final FirebaseMessaging messaging;

  // Local notifications nesnesi
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Constructor
  FirebaseNotificationService();

  // Local Notifications yapılandırması
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Bildirimi gösterme fonksiyonu
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // Kanal ID'si
      'High Importance Notifications', // Kanal adı
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _localNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? "Başlık", // Başlık
      message.notification?.body ?? "İçerik", // İçerik
      notificationDetails,
    );


  }

  // Bildirimi gösterme fonksiyonu
  Future<void> _showNotificationZonedSchedule(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // Kanal ID'si
      'High Importance Notifications', // Kanal adı
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // await _localNotificationsPlugin.(
    //
    //   androidScheduleMode: AndroidScheduleMode.alarmClock,
    //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    //
    // );


  }

  // Kullanıcıdan izin alma
  void requestPermission() async {
    await messaging.requestPermission(alert: true, sound: true, badge: true);
  }

  // Bildirimleri dinleme
  void connectNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    // Local Notifications başlatma
    await _initLocalNotifications();

    // Firebase bildirim ayarları
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print("Bildirim Alındı: ${message.notification?.title}");
        _showNotification(message); // Gelen bildirimi göster
      },
    );

    // Cihaz Token'ını göster
    messaging.getToken().then((value) {
      print("Cihaz Token: $value");
    });

    requestPermission();
  }
}
