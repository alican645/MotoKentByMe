import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkAutoLogin();
    });
  }

  Future<void> _checkAutoLogin() async {
    LocalStorage localStorage = LocalStorageImpl();
    final username = await localStorage.getValue<String>("username");
    final password = await localStorage.getValue<String>("password");

    try {
      if (username != null && password != null) {
        var response = await context.read<LoginViewmodel>().loginRequest({
          'password': password,
          'email': username,
        });
        if (response.statusCode == 200) {
          if (!mounted) return;
          context.go(AppRoutes.explorePage); // Ana sayfaya yönlendirin
        } else {
          if (!mounted) return;
          context.go(AppRoutes.loginPage);
        }
      } else {
        if (!mounted) return;
        context.go(AppRoutes.loginPage);
      }
    } catch (e) {
      log(e.toString(), error: e, name: "Otomatik Giriş Hatası");
      if (!mounted) return;
      context.go(AppRoutes.loginPage);
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
