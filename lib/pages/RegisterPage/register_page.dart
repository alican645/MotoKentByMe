import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/components/my_textfile.dart';
import 'package:moto_kent/models/register_model.dart';
import 'package:moto_kent/pages/RegisterPage/register_viewmodel.dart';
import 'package:moto_kent/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();




  Future<void> registerUser () async{
    var registerModel = RegisterModel(
      password: passwordController.text,
      email: emailController.text,
      confirmPassword: confirmPasswordController.text,
      fullName: fullNameController.text
    );

    if (registerModel.password != registerModel.confirmPassword) {
      _showErrorDialog(context, 'Hata', 'Şifreler eşleşmiyor.');
      return;
    }

    try{
      var response=await context.read<RegisterViewmodel>().registerRequest(registerModel.toJson());

      if(!mounted) return;

      if (response.statusCode == 201) {
        _showSuccessDialog(context,"Başarılı","Kayıt Başarılı");
      } else {
        _showErrorDialog(context, "Başarısız", "Kayıt Bşarısız lütfen tekrar deneyiniz");
      }
    }catch(e){
      _showErrorDialog(context, "Başarısız", e.toString());
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
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Consumer<RegisterViewmodel>(builder: (context, value, child) =>
           LoadingOverlay(
            isLoading: value.isCompleted,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0), // Alt kısma ek boşluk
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // Logo
                    const Icon(
                      Icons.person_add,
                      size: 100,
                    ),

                    const SizedBox(height: 50),

                    // "MotoKent'e hoş geldiniz" başlığı
                    const Text(
                      "MotoKent'e Hoşgeldiniz!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24, // Daha büyük font boyutu
                        fontWeight: FontWeight.bold, // Kalın yazı stili
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Hoş geldiniz
                    Text(
                      "Yeni bir hesap oluşturun",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Ad soyad textfield
                    MyTextField(
                      controller: fullNameController,
                      hintText: 'Ad Soyad',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

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

                    // Kayıt ol butonu
                    MyButton(
                      onTap: () async {
                        await registerUser();
                      },
                      text: "Kayıt Ol",
                    ),
                    TextButton(onPressed: () async  {
                      await registerUser();
                    }, child: const Text("Kayıt Ol")),
                    const SizedBox(height: 50),

                    // Zaten üye misiniz? Giriş yapın
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Zaten üye misiniz?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            context.go('/login_page');
                          },
                          child: const Text(
                            'Kayıt Ol!',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
