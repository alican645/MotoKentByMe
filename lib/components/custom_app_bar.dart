import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

   CustomAppBar({super.key,this.title,this.actions,this.bottom})
      : preferredSize = bottom==null?const Size.fromHeight(60.0):Size.fromHeight(60.0 + bottom.preferredSize.height);

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
        centerTitle: true,
        bottom:bottom ,
        title: title==null?const Text(""):Text(title!),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: actions,
      ),
    );
  }
}


