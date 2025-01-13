import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const CustomAppBar({super.key})
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
      decoration: appBarBoxDecoration,
      child: AppBar(
        title: Image.asset(
          'assets/images/moto_kent_logo.png', // Resminizin assets klasöründeki yolu
          height: 60, // Resim yüksekliğini ayarlayın
          fit: BoxFit.fitWidth,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
