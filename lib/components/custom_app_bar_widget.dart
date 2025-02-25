import 'package:flutter/material.dart';

import 'package:moto_kent/app/app_theme.dart';

class CustomAppBar22 extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final List<Widget>? actions;
  final bool? right;


  CustomAppBar22({super.key, this.actions, this.right = false,})
      : preferredSize = const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    var appBarBoxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.primary,
          Colors.white,
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.themeData.colorScheme.primary,
            Colors.white,
          ],
        ),
      ),
      child: AppBar(
        centerTitle: true,
        title: Align(
          alignment: right! ? Alignment.centerRight : Alignment.centerLeft,
          child: Image.asset(
            'assets/images/moto_kent_logo.png', // Resminizin assets klasöründeki yolu
            height: 60, // Resim yüksekliğini ayarlayın
            fit: BoxFit.fitWidth,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: actions,
      ),
    );
  }
}
