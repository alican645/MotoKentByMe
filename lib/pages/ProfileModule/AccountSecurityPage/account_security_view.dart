

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/build_list_tile.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/components/list_section_title.dart';
import 'package:moto_kent/constants/app_routes.dart';

class AccountSecurityView extends StatelessWidget {
  const AccountSecurityView({super.key});
  
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Hesap Güvenliği"),),
      body: Column(
        children: [

          const ListSectionTitle(title: "Şifre"),
           BuildListTile(icon: Icons.lock, title: "Şifreyi değiştir.",onTap: () {
            context.go("${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.accountSecurityPage}/${AppRoutes.changePasswordPage}");
          },),
          
          const ListSectionTitle(title: "Email"),
          //const BuildListTile(icon: Icons.check, title: "Email adresini onayla."),
          BuildListTile(icon: Icons.email, title: "Email adresini değiştir.",onTap: () {
            context.go("${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.accountSecurityPage}/${AppRoutes.changeEmailPage}");
          },),

          const ListSectionTitle(title: "Gizlilik Sözleşmesi"),
          const BuildListTile(icon: Icons.file_open, title: "Gizlilik sözleşmesini gör"),

          const ListSectionTitle(title: "Hesap"),
          BuildListTile(icon: Icons.delete, title: "Hesabı kaldır.",onTap: () {
            
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Hesabı kaldırmak için lütfen şifrenizi giriniz"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(controller: _controller, hintText: "Şifrenizi Giriniz"),
                      SizedBox(height: 20,),
                      CustomTextField(controller: _controller2, hintText: "Şifrenizi Onaylayınız"),
                    ],
                    
                  ),
                  
                ),
                actions: [
                 TextButton(onPressed: () {
                   
                 }, child: Text("Kaldır"))
                ],
              );
            },);

          },),
        ],
      ),
    );
  }
}