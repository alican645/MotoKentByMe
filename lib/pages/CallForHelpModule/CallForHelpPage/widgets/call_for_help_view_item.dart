

import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';

class CallForHelpViewItem extends StatelessWidget {
  const CallForHelpViewItem(
      {super.key,
        required this.path,
        required this.explanation,
        required this.onPressed});
  final String path;
  final String explanation;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              border:
              Border.all(width: 2, color: AppTheme.themeData.primaryColor)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Flexible(
                  child: Image.asset(
                    path,
                    fit: BoxFit.fill,
                    width: MediaQuery.sizeOf(context).width / 4,
                  ),
                ),
                Text(explanation)
              ],
            ),
          ),
        ),
      ),
    );
  }
}