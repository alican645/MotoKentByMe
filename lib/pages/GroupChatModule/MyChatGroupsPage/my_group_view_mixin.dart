import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';

mixin MyGroupsViewMixin on State<MyGroupsView> {
  void goToMessagePage(MyGroupsViewmodel value, int index) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    Map<String, dynamic> object = {
      "userId": userId!,
      "groupId": value.groupsList[index].chatGroupId!,
      "userName": "username",
      "groupName": value.groupsList[index].name!
    };
    if (!mounted) return;
    context.push(
        '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}/${AppRoutes.messagePage}',
        extra: object);
  }

  void showMyChatGroupsDialog();
}
