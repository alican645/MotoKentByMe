
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_button_22.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_view_mixin.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_viewmodel.dart';
import 'package:moto_kent/services/permission_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with LoginViewMixin {
  @override
  void initState() {
    super.initState();
    PermissionService(context).initializePermissions();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
              if (value.isCompleted == false) {
                return const CustomLoadingWidget();
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
                          topRight: Radius.circular(16),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Şifremi Unuttum',
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          CustomButton22(
                            color: Colors.black,
                            splashColor: Colors.grey,
                            onPressed: () => login(),
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
                                  context
                                      .push(AppRoutes.registerUserProfilePage);
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

  @override
  void showScaffoldMessenger(String message, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
}
