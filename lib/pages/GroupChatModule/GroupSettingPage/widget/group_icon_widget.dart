import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';

class GroupIconWidget extends StatelessWidget {
  const GroupIconWidget({super.key, required this.iconPath});
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 102,
        height: 102,
        decoration: BoxDecoration(
            border:
            Border.all(color: AppTheme.themeData.primaryColor, width: 3),
            borderRadius: BorderRadius.circular(90)),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(
            '${ApiConstants.baseUrl}/$iconPath',
          ),
        ),
      ),
    );
  }
}
