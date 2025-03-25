import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.data});
  final Map<String, dynamic>? data;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String? route = widget.data?["route"] as String?;
      if (route != null) {
        _checkAutoLogin(false, route: widget.data!["route"]);
      } else {
        _checkAutoLogin(true, route: null);
      }
    });
  }

  Future<void> _checkAutoLogin(bool isNormalLogin, {String? route}) async {
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
          if (isNormalLogin) {
            context.go(AppRoutes.explorePage); // Ana sayfaya yönlendirin
          } else {
            context.go(route!, extra: widget.data!["locationModel"]);
          }
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
