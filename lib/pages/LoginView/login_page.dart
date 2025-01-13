import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/login_response_model.dart';
import 'package:moto_kent/pages/LoginView/login_viewmodel.dart';
import 'package:moto_kent/services/permission_service.dart';
import 'package:provider/provider.dart';
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
  Future<void> signUserIn(bool isAutoLogin,
      {String? username, String? password}) async {
    final username;
    final password;

    //final username = "alican@gmail.com";
    //final password = "Alican123.";
    //final username = "motokent@gmail.com";
    //final password = "Motokent123.";

    if (isAutoLogin) {
      username = await SharedPreferencesHelper().getValue<String>("username");
      password = await SharedPreferencesHelper().getValue<String>("password");
    } else {
      username = usernameController.text;
      password = passwordController.text;
    }

    try {
      var response = isAutoLogin
          ? await context.read<LoginViewmodel>().loginRequestWithSp({
              'password': password,
              'email': username,
            })
          : await context.read<LoginViewmodel>().loginRequest({
              'password': password,
              'email': username,
            });
      if (response.statusCode == 200) {
        var loginResponseData = LoginResponseModel.fromJson(response.data);
        String token = loginResponseData.token!;
        String refreshToken = loginResponseData.refreshToken!;
        String expiration = loginResponseData.expiration!.toString();
        String userId = loginResponseData.userId!; // Kullanıcı ID'sini aldık

        await SharedPreferencesHelper().setValue<String>('jwt_token', token);
        await SharedPreferencesHelper()
            .setValue<String>('refresh_token', refreshToken);
        await SharedPreferencesHelper()
            .setValue<String>('token_expiration', expiration);
        await SharedPreferencesHelper()
            .setValue<String>('user_id', userId); // Kullanıcı ID'sini kaydettik
        await SharedPreferencesHelper().setValue<String>("username", username);
        await SharedPreferencesHelper().setValue<String>("password", password);
        context.go('/profile_page');
      } else {
        _showErrorDialog(context, 'Giriş Başarısız', response.data);
      }
    } catch (e) {
      _showErrorDialog(context, "Giriş Başarışız", e.toString());
    } finally {}
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
              onPressed: () {

                    Navigator.pop(context);

              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> AutoLoginWithSP() async {
    //SharedPreferencesHelper().setValue("username", "motokent@gmail.com");
    //SharedPreferencesHelper().setValue("password", "Motokent123.");
    String? username =
        await SharedPreferencesHelper().getValue<String>("username");
    String? password =
        await SharedPreferencesHelper().getValue<String>("password");
    if (username == null || password == null) {
      return false;
    } else {
      await signUserIn(true, username: username, password: password);
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    PermissionService(context).initializePermissions();


  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder(
        future: AutoLoginWithSP() ,
        builder: (context, snapshot) {
          if(snapshot.data==null){
            return Scaffold(body: CustomLoadingWidget());
          }
          if(snapshot.data==true){
            return Scaffold(body: CustomLoadingWidget());
          }

          return LoadingOverlay(
          isLoading: context.watch<LoginViewmodel>().isCompleted,
          child: Scaffold(
            backgroundColor: AppTheme.themeData.primaryColor,
            body: SafeArea(
              child: Consumer<LoginViewmodel>(
                builder: (context, value, child) => SingleChildScrollView(
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
                            MyButton(
                              onTap: () => signUserIn(false),
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
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
