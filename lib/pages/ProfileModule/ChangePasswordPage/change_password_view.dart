import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/components/my_button.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/ProfileModule/ChangePasswordPage/change_password_view_mixin.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}


class _ChangePasswordViewState extends State<ChangePasswordView>
    with ChangePasswordViewMixin {
  @override
  void showValidationFalseMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Şifreler Eşleşmiyor")));
  }

  @override
  void passwordIsChanged() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Şifreniz başarılı bir şekilde değiştirildi")));
  }
  @override
  void logout() =>context.go(AppRoutes.loginPage);

  @override
  void passwordIsNotChange() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tekrar deneyiniz.")));
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şifre Değiştir"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: controller,
              hintText: "Güncel Şifrenizi Giriniz",
              type: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: controller2,
              hintText: "Yeni Şifrenizi Giriniz",
              type: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: controller3,
              hintText: "Yeni Şifrenizi Onaylayınız",
              type: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
                onTap: () async {
                  changePassword();
                },
                text: "Şifreyi Değiştir")
          ],
        ),
      ),
    );
  }
}
