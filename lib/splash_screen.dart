import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.data}) : super(key: key);
  final Map<String, dynamic>? data;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Widget ağacı oluşturulduktan sonra yönlendirme işlemini başlatıyoruz.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    final Map<String, dynamic>? payload = widget.data;
    // Eğer bildirimle giriş yapılmışsa (veya arka plan bildirimi değilse)
    if (payload != null && payload["isBackGround"] != true) {
      _navigateBasedOnNotification(payload);
    } else {
      await _attemptAutoLogin();
    }
  }

  Future<void> _attemptAutoLogin() async {
    final LocalStorage localStorage = LocalStorageImpl();
    final username = await localStorage.getValue<String>("username");
    final password = await localStorage.getValue<String>("password");

    if (username == null || password == null) {
      log("Kullanıcı adı veya şifre eksik, giriş sayfasına yönlendiriliyor.",
          name: "login exception");
      if (mounted) context.go(AppRoutes.loginPage);
      return;
    }

    try {
      final response = await context.read<LoginViewmodel>().loginRequest({
        'password': password,
        'email': username,
      });

      if (response.statusCode == 200) {
        // Başarılı giriş: Eğer bildirim verisi varsa onu işleyelim.
        if (widget.data != null) {
          _navigateBasedOnNotification(widget.data!);
        } else {
          context.go(AppRoutes.explorePage);
        }
      } else {
        log("Yanlış şifre veya kullanıcı bilgisi", name: "login exception");
        if (mounted) context.go(AppRoutes.loginPage);
      }
    } catch (e) {
      log("Giriş sırasında hata: $e", name: "login exception");
      if (mounted) context.go(AppRoutes.loginPage);
    }
  }

  void _navigateBasedOnNotification(Map<String, dynamic> payload) {
    final notificationType = payload["notificationType"] as String?;
    if (notificationType == null) {
      log("Bildirim türü eksik, normal girişe yönlendiriliyor",
          name: "login exception");
      context.go(AppRoutes.explorePage);
      return;
    }

    switch (notificationType) {
      case "9":
        log("Bildirim girişi: Harita Ekranı", name: "login exception");
        context.go(AppRoutes.mapPage, extra: payload);
        break;
      case "1":
        context.go(
            '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}/${AppRoutes.messagePage}',
            extra: payload);
        break;
      case "0":
        context.push(
          '${AppRoutes.explorePage}/${AppRoutes.myPrivateMessagesPage}/${AppRoutes.privateChatPage}',
          extra: payload,
        );
        break;
      default:
        log("Bilinmeyen bildirim türü, normal girişe yönlendiriliyor",
            name: "login exception");
        context.go(AppRoutes.explorePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Text(
          'Moto-Kent',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),
        ),
      ),
    );
  }
}
