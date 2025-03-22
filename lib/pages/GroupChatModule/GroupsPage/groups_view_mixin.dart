import 'package:flutter/material.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_view.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_viewmodel.dart';
import 'package:provider/provider.dart';

mixin ChatGroupsViewMixin on State<ChatGroupsView> {
  Future<void> joinChatGroup(int groupId) async {
    try {
      var response = await context
          .read<ChatGroupsViewmodel>()
          .joinRequestChatGroup(groupId);
      if (response.statusCode == 200) {
        showScaffoldMessenger("Katılma İsteği Gönderildi");
      } else {
        showScaffoldMessenger(response.data);
      }
    } catch (e) {
      showScaffoldMessenger(e.toString());
    }
  }

  void joinChatGropShowDialog(int groupId);
  void showScaffoldMessenger(String message);
}
