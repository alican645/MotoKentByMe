import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/pages/ProfileModule/ChangeEmailPage/change_email_view_mixin.dart';
import 'package:moto_kent/pages/ProfileModule/ChangeEmailPage/change_email_viewmodel.dart';
import 'package:provider/provider.dart';

class ChangeEmailView extends StatefulWidget {
  const ChangeEmailView({super.key});

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<ChangeEmailView> with ChangeEmailViewMixin{

  @override
  void showValidationNotEmailFormatMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Email formatınız yanlış")));
  }
  @override
  void showValidationFalseMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Şifreler Eşleşmiyor")));
  }
  @override
  void emailIsChanged() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Email adresi başarılı bir şekilde değiştirildi")));
  }

  @override
  void emailIsNotChange() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Lütfen Tekrar Deneyiniz")));
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
    controller2.dispose();
    controller3.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text("Email Adresini Değiştir"),
      centerTitle: true,
      ),
      body: Padding(
 padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(controller: controller, hintText: "Yeni Email Adresinizi Giriniz"),
            const SizedBox(height: 20,),
            CustomTextField(controller: controller2, hintText: "Güncel Şifrenizi Giriniz"),
            const SizedBox(height: 20,),
            CustomTextField(controller: controller3, hintText: "Güncel Şifrenizi Onaylayınız"),
            const SizedBox(height: 30,),
            MyButton(onTap: () async{
              changeEmail(context.read<ChangeEmailViewmodel>());
            }, text: "Email Adresini Değiştir")
          ],
        ),
      ),
    );
  }





}