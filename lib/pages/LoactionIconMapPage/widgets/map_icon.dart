

import 'package:flutter/material.dart';
import 'package:moto_kent/app/app_theme.dart';

class MapIcon extends StatelessWidget {
  const MapIcon({super.key, required this.iconData, required this.onPressed});
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: AppTheme.themeData.primaryColor,
        borderRadius: BorderRadius.circular(45),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}