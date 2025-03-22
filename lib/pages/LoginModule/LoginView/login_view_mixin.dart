import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_page.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_viewmodel.dart';
import 'package:provider/provider.dart';

mixin LoginViewMixin on State<LoginPage> {
  final _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;
  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  void showScaffoldMessenger(String message, Color color);

  Future<void> login() async {
    final username = usernameController.text;
    final password = passwordController.text;
    try {
      var response = await context.read<LoginViewmodel>().loginRequest({
        'password': password,
        'email': username,
      });
      if (response.statusCode == 200) {
        LocalStorage localStorage = LocalStorageImpl();
        await localStorage.setValue<String>("username", username);
        await localStorage.setValue<String>("password", password);
        if (!mounted) return;
        context.go(AppRoutes.profilePage); // Ana sayfaya yönlendirin
      } else {
        showScaffoldMessenger(
            'Giriş başarısız. Lütfen tekrar deneyin.', Colors.red);
      }
    } catch (e) {
      log(e.toString(), error: e, name: "Giriş Hatası");
      showScaffoldMessenger(
          'Giriş başarısız. Lütfen tekrar deneyin.', Colors.red);
    }
  }
}
