


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/pages/GroupsPage/widgets/build_button.dart';

class BottomButonsBar extends StatelessWidget {
  const BottomButonsBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppTheme.themeData.colorScheme.primary,
              Colors.white,
            ],)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BuildButton(
                onPressed: () {
                  context.go("/chat_groups_page/my_groups");
                },
                icon: const Icon(
                  Icons.person_2_outlined,
                  size: 48,
                ),
                content: "Gruplarım"),
            BuildButton(
                onPressed: () {
                  context.go("/chat_groups_page/create_chat_group");
                },
                icon: const Icon(
                  Icons.add,
                  size: 48,
                ),
                content: "Oluştur"),
            BuildButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_rounded,
                  size: 48,
                ),
                content: "Ara")
          ],
        ),
      ),
    );
  }
}
