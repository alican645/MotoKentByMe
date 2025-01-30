import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/pages/LoginView/login_viewmodel.dart';
import 'package:moto_kent/services/permission_service.dart';
import 'package:provider/provider.dart';

//final username = "alican@gmail.com";
//final password = "Alican123.";
//final username = "motokent@gmail.com";
//final password = "Motokent123.";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PermissionService(context).initializePermissions();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    //await SharedPreferencesHelper().setValue<String>("username", "alican@gmail.com");
    //await SharedPreferencesHelper().setValue<String>("password", "Alican123.");
    final username =
        await SharedPreferencesHelper().getValue<String>("username");
    final password =
        await SharedPreferencesHelper().getValue<String>("password");

    try {
      if (username != null && password != null) {
        var response = await context.read<LoginViewmodel>().loginRequest({
          'password': password,
          'email': username,
        });
        if (response.statusCode == 200) {
          context.go('/profile_page'); // Ana sayfaya yönlendirin
        }
      }
    } catch (e) {
      log(e.toString(), error: e, name: "Otomatik Giriş Hatası");
    }
  }

  Future<void> _login() async {
    final username = usernameController.text;
    final password = passwordController.text;
    try {
      var response = await context.read<LoginViewmodel>().loginRequest({
        'password': password,
        'email': username,
      });
      if (response.statusCode == 200) {
        await SharedPreferencesHelper().setValue<String>("username", username);
        await SharedPreferencesHelper().setValue<String>("password", password);
        context.go('/profile_page'); // Ana sayfaya yönlendirin
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giriş başarısız. Lütfen tekrar deneyin.')),
        );
      }
    } catch (e) {
      log(e.toString(), error: e, name: "Giriş Hatası");
      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(content: Text('Giriş başarısız. Lütfen tekrar deneyin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.themeData.primaryColor,
        body: SafeArea(
          child: Consumer<LoginViewmodel>(
            builder: (context, value, child) {
              if(value.isCompleted==false){
                return CustomLoadingWidget();
              }
              return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.lock, size: 100),
                  const SizedBox(height: 50),
                  Text(
                    "MotoKent'e Hoşgeldiniz!",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        MyTextField(
                          controller: usernameController,
                          hintText: 'E-mail',
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Şifre',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Şifremi Unuttum',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyButton(
                          onTap: () => _login(),
                          text: "Giriş Yap",
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Üye değil misiniz?',
                                style: TextStyle(color: Colors.grey[700])),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                context.push('/register_page');
                              },
                              child: const Text(
                                'Şimdi kayıt olun!',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }
}
