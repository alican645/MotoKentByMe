import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  String? data;
  List<Widget>? actions;

   CustomAppBar({super.key,this.data,this.actions})
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
        centerTitle: true,
        title: data==null?const Text(""):Text(data!),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: actions,
      ),
    );
  }
}
