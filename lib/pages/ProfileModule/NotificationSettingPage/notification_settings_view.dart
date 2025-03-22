import 'package:flutter/material.dart';
import 'package:moto_kent/components/build_list_tile.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/list_section_title.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Bildirim Ayarları",
      ),
      body: Column(
        children: [
          const ListSectionTitle(title: 'Genel'),
          BuildListTile(
            icon: Icons.notifications,
            title: 'Grup Sohbetleri',
            trailing: Switch(
              value: false,
              onChanged: (boolValue) async {},
            ),
          ),
          BuildListTile(
            icon: Icons.notifications,
            title: 'Şahsi Sohbetler',
            trailing: Switch(
              value: false,
              onChanged: (boolValue) async {},
            ),
          ),
          BuildListTile(
            icon: Icons.notifications,
            title: 'Yardım Çağrıları',
            trailing: Switch(
              value: false,
              onChanged: (boolValue) async {},
            ),
          ),
          BuildListTile(
            icon: Icons.notifications,
            title: 'Etkileşimler',
            trailing: Switch(
              value: false,
              onChanged: (boolValue) async {},
            ),
          ),
        ],
      ),
    );
  }
}
