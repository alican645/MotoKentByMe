import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/widgets/build_button.dart';
import 'package:provider/provider.dart';

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
        ],
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BuildButton(
                onPressed: () {
                  context.push(
                      '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}');
                },
                icon: const Icon(
                  Icons.person_2_outlined,
                  size: 30,
                ),
                content: "Gruplarım"),
            BuildButton(
                onPressed: () {
                  context.push(
                      '${AppRoutes.chatGroupsPage}/${AppRoutes.createChatGroup}');
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),
                content: "Oluştur"),
            BuildButton(
                onPressed: () {
                  context.push(
                      '${AppRoutes.chatGroupsPage}/${AppRoutes.searchChatGroupPage}');
                },
                icon: const Icon(
                  Icons.search_rounded,
                  size: 30,
                ),
                content: "Ara"),
            BuildButton(
                onPressed: () {
                  context.read<ChatGroupsViewmodel>().fetchChatGropsList();
                },
                icon: const Icon(
                  Icons.refresh_outlined,
                  size: 30,
                ),
                content: "Yenile"),
          ],
        ),
      ),
    );
  }
}
