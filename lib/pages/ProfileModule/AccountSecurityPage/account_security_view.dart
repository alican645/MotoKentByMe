import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/build_list_tile.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/components/list_section_title.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/ProfileModule/AccountSecurityPage/account_security_view_mixin.dart';

class AccountSecurityView extends StatefulWidget {
  const AccountSecurityView({super.key});

  @override
  State<AccountSecurityView> createState() => _AccountSecurityViewState();
}

class _AccountSecurityViewState extends State<AccountSecurityView>
    with AccountSecurityViewMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesap Güvenliği"),
      ),
      body: Column(
        children: [
          const ListSectionTitle(title: "Şifre"),
          BuildListTile(
            icon: Icons.lock,
            title: "Şifreyi değiştir.",
            onTap: () {
              context.go(
                  "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.accountSecurityPage}/${AppRoutes.changePasswordPage}");
            },
          ),
          const ListSectionTitle(title: "Email"),
          BuildListTile(
            icon: Icons.email,
            title: "Email adresini değiştir.",
            onTap: () {
              context.go(
                  "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.accountSecurityPage}/${AppRoutes.changeEmailPage}");
            },
          ),
          const ListSectionTitle(title: "Gizlilik Sözleşmesi"),
          const BuildListTile(
              icon: Icons.file_open, title: "Gizlilik sözleşmesini gör"),
          const ListSectionTitle(title: "Hesap"),
          BuildListTile(
            icon: Icons.delete,
            title: "Hesabı kaldır.",
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                        "Hesabı kaldırmak için lütfen şifrenizi giriniz"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomTextField(
                              controller: controller,
                              hintText: "Şifrenizi Giriniz"),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                              controller: controller2,
                              hintText: "Şifrenizi Onaylayınız"),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text("Kaldır"))
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
