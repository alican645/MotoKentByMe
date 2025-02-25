import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_button_22.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/models/register_model.dart';
import 'package:moto_kent/pages/LoginModule/RegisterPage/register_viewmodel.dart';
import 'package:moto_kent/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, this.registerModel});
  final RegisterModel? registerModel;

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> registerUser() async {
    var registerModel = widget.registerModel!;
    registerModel.email=emailController.text;
    registerModel.password=passwordController.text;
    registerModel.confirmPassword=confirmPasswordController.text;
    if (registerModel.password != registerModel.confirmPassword) {
      _showErrorDialog(context, 'Hata', 'Şifreler eşleşmiyor.');
      return;
    }

    try {
      var response = await context
          .read<RegisterViewmodel>()
          .registerRequest(registerModel.toJson());

      if (!mounted) return;

      if (response.statusCode == 201) {
        _showSuccessDialog(context, "Başarılı", response.data.toString());
      } else {
        _showErrorDialog(
            context, "Başarısız", "Kayıt Bşarısız lütfen tekrar deneyiniz");
      }
    } catch (e) {
      _showErrorDialog(
          context, "Başarısız", "Kayıt Bşarısız lütfen tekrar deneyiniz");
    }
  }

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

  void _showSuccessDialog(BuildContext context, String title, String message) {
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
                context.go('/login_page');
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: LoadingOverlay(
        isLoading: context.watch<RegisterViewmodel>().isCompleted,
        child: Scaffold(
          backgroundColor: AppTheme.themeData.primaryColor,
          body: SafeArea(
            child: Consumer<RegisterViewmodel>(
              builder: (context, value, child) => SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const Icon(
                      Icons.person_add,
                      size: 100,
                    ),
                    Text(
                      "Yeni bir hesap oluşturun",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
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
                          const SizedBox(height: 50,),
                          // Email textfield
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                          ),

                          const SizedBox(height: 10),

                          // Şifre textfield
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Şifre',
                            obscureText: true,
                          ),

                          const SizedBox(height: 10),

                          // Şifre tekrar textfield
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Şifre Tekrar',
                            obscureText: true,
                          ),

                          const SizedBox(height: 25),

                          CustomButton22(
                            color: Colors.black,
                            splashColor: Colors.grey,

                            onPressed: () async {
                              await registerUser();
                            },
                            text: "Kayıt Ol",
                          ),],
                      ),
                    ),
                    // Ad soyad textfield

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
