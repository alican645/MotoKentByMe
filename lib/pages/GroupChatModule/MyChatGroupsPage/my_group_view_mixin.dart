import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';

mixin MyGroupsViewMixin on State<MyGroupsView> {
  void goToMessagePage(MyGroupsViewmodel value, int index) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    String? userfullname =
        await LocalStorageImpl().getValue<String>("userfullname");

    Map<String, dynamic> object = {
      "userId": userId!,
      "groupId": value.lastGroupMessageList[index].chatGroupId!,
      "userName": userfullname,
      "groupName": value.lastGroupMessageList[index].chatGroupName!,
      "groupIndex": index,
    };
    if (!mounted) return;
    context.push(
        '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}/${AppRoutes.messagePage}',
        extra: object);
  }

  void showMyChatGroupsDialog();
}
