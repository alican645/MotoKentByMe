import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/list_section_title.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyAppSettingsViewmodel>().loadProfileData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        await context.read<MyAppSettingsViewmodel>().loadProfileData();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ayarlar'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Consumer<MyAppSettingsViewmodel>(
            builder: (context, value, child) {
              if (value.isLoading == false) {
                return Container(
                  height: MediaQuery.sizeOf(context).height / 2,
                  child: const Center(child: CustomLoadingWidget()),
                );
              }
              return Column(children: [
                // Profil Bilgileri
                ProfileHeader(
                  fullName: value.userModel!.fullName!,
                  username: value.userModel!.email!,
                  userProfilePhotoPath: value.userModel!.profilePhotoPath!,
                  onPressed: () {
                    context.go(
                        "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.editProfilePage}");
                  },
                ),

                const ListSectionTitle(title: 'Genel'),

                BuildListTile(
                    icon: Icons.security,
                    title: 'Bilidirm Ayarları',
                    onTap: () {
                      context.push(
                          "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.notificationSettingsPage}");
                    }),

                const ListSectionTitle(title: 'Hesap'),
                BuildListTile(
                    icon: Icons.security,
                    title: 'Hesap Güvenliği',
                    onTap: () {
                      context.push(
                          "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.accountSecurityPage}");
                    }),

                BuildListTile(
                    icon: Icons.person_2,
                    title: 'Engellenmiş Kullanıcılar',
                    onTap: () {}),
                BuildListTile(
                    icon: Icons.person_2,
                    title: 'Postlarım',
                    onTap: () {
                      context.push(
                          "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.myPostsPage}");
                    }),
                const BuildListTile(
                  icon: Icons.help,
                  title: 'Yardım Merkezi',
                ),
                BuildListTile(
                  icon: Icons.info,
                  title: 'Hakkında',
                  onTap: () {
                    context.push(
                        "${AppRoutes.profilePage}/${AppRoutes.myAppSettingPage}/${AppRoutes.aboutPage}");
                  },
                ),

                // Çıkış Yap Butonu
                const ListSectionTitle(title: 'Çıkış'),
                BuildListTile(
                  icon: Icons.logout_sharp,
                  title: 'Çıkış Yap',
                  onTap: () =>
                      context.read<MyAppSettingsViewmodel>().logOut(context),
                ),
                //LogoutButton(context: context),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
