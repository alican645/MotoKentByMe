import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/models/login_response_model.dart';
import 'package:moto_kent/pages/LoginView/login_viewmodel.dart';
import 'package:moto_kent/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_kent/widgets/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  // Kullanıcı giriş yapma fonksiyonu
  Future<void> signUserIn() async {
    final username = usernameController.text;
    final password = passwordController.text;
    // final username = "alicanaydin@gmail.com";
    // final password = "Alican0391.";
    // final username = "alican@gmail.com";
    // final password = "Alican0391.";
    // final username ='ali@gmail.com';
    //aliii@gmail.com

    try {

    var response=await context.read<LoginViewmodel>().loginRequest({
      'email': username,
      'password': password,
    });
      if (response.statusCode == 200) {
        var loginResponseData = LoginResponseModel.fromJson(response.data);
        String token = loginResponseData.token!;
        String refreshToken = loginResponseData.refreshToken!;
        String expiration = loginResponseData.expiration!.toString();
        String userId = loginResponseData.userId!; // Kullanıcı ID'sini aldık

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('token_expiration', expiration);
        await prefs.setString('user_id', userId); // Kullanıcı ID'sini kaydettik

        context.go('/profile_page');
      }
      else {
        var errorResponse = jsonDecode(utf8.decode(response.data));
        String errorMessage = errorResponse['Errors']?.first ?? 'Beklenmeyen bir hata oluştu.';
        _showErrorDialog(context, 'Giriş Başarısız', errorMessage);
      }
    } catch (e) {
      _showErrorDialog(context, 'Hata', 'Sunucuda bir hata oluştu. Lütfen daha sonra tekrar deneyin.');
    } finally {

    }


  }

  // Hata mesajı gösteren dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PermissionService(context).initializePermissions();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Consumer<LoginViewmodel>(builder:(context, value, child) => LoadingOverlay(
          isLoading: value.isCompleted,
          child: SingleChildScrollView( // Ekranın kaydırılabilir olmasını sağlar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                        Text('Şifremi Unuttum', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: () => signUserIn(),
                    text: "Giriş Yap",
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Üye değil misiniz?', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          context.go('/register_page');
                        },
                        child: const Text(
                          'Şimdi kayıt olun!',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50), // Alt boşluk
                ],
              ),
            ),
          ),
        ),),
      ),
    );
  }
}
