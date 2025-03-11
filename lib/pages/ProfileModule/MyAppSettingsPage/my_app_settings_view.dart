import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/list_section_title.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/ProfileModule/MyAppSettingsPage/my_app_settings_viewmodel.dart';
import 'package:moto_kent/components/build_list_tile.dart';
import 'package:moto_kent/pages/ProfileModule/MyAppSettingsPage/widgets/profile_header.dart';
import 'package:provider/provider.dart';

class MyAppSettingsView extends StatefulWidget {
  const MyAppSettingsView({super.key});

  @override
  State<MyAppSettingsView> createState() => _MyAppSettingsViewState();
}

class _MyAppSettingsViewState extends State<MyAppSettingsView> {
  @override 
  void initState(){
    super.initState();
    context.read<MyAppSettingsViewmodel>().loadProfileData();
    context.read<MyAppSettingsViewmodel>().loadNotificationStatus();

  }
  @override
  Widget build(BuildContext context) {
    
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        await context.read<MyAppSettingsViewmodel>().loadProfileData();
      } ,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ayarlar'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Consumer<MyAppSettingsViewmodel>(
            builder: (context, value, child) => 
             Column(children: [
              // Profil Bilgileri
              ProfileHeader(
                fullName: value.currentName!,
                username: value.currentEmail!,
                userProfilePhotoPath: value.userProfilePhotoPath!,
                onPressed: () {
                  String bio = value.bio??"";
                  List<String> payload = [value.currentName!,'${ApiConstants.baseUrl}/${value.userProfilePhotoPath!}',bio];
                  context.go("${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.editProfilePage}",extra: payload);
                },
              ),
            
              const ListSectionTitle(title: 'Genel'),
              BuildListTile(
            
                icon: Icons.notifications,
                title: 'Bildirimler', 
                trailing: Switch(value: value.isNotificationEnabled, onChanged: (boolValue) async {
                  context.read<MyAppSettingsViewmodel>().toggleNotification(boolValue);
                },), 
              ),
            
              const ListSectionTitle(title: 'Hesap'),
               BuildListTile(
                icon: Icons.security,
                title: 'Hesap Güvenliği',
                onTap: () {
                  context.go("${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.accountSecurityPage}");
                }
              ),
              
               BuildListTile(
                icon: Icons.person_2,
                title: 'Engellenmiş Kullanıcılar',
                onTap: () {
                  
                }
              ),
               const BuildListTile(
                icon: Icons.help,
                title: 'Yardım Merkezi',
                ),
               BuildListTile(
                icon: Icons.info,
                title: 'Hakkında',
                onTap: () {
                  context.push(AppRoutes.aboutPage);
                },
              ),
            
              // Çıkış Yap Butonu
              const ListSectionTitle(title: 'Çıkış'),
               BuildListTile(
                icon: Icons.logout_sharp,
                title: 'Çıkış Yap',
                onTap: () => context.read<MyAppSettingsViewmodel>().logOut(context),
              ),
              //LogoutButton(context: context),
            ]),
          ),
        ),
      ),
    );
  }
}



