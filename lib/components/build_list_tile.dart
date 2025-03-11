import 'package:flutter/material.dart';
import 'package:moto_kent/app/app_theme.dart';

class BuildListTile extends StatelessWidget {
  const BuildListTile(
      {super.key,
      required this.icon,
      this.subtitle,
      required this.title,
      this.onTap,
      this.trailing});

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.themeData.primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap:onTap,
    );
  }
}
