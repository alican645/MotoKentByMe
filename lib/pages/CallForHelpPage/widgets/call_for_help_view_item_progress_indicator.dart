

import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';

class CallForHelpViewItemProgressIndicator extends StatelessWidget {
  const CallForHelpViewItemProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border:
            Border.all(width: 2, color: AppTheme.themeData.primaryColor)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

