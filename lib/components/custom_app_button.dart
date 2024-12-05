
import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton({
    super.key,
    required this.btnText,
    required this.onPressed,
    required this.btnWidth
  });

  final String btnText;
  final VoidCallback onPressed;
  final double btnWidth;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: btnWidth,
        decoration: BoxDecoration(
            color: AppTheme.themeData.colorScheme.primary,
            borderRadius: BorderRadius.circular(16)),
        child:  Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              btnText,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}