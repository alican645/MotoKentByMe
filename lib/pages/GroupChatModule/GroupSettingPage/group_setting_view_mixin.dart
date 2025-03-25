import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/models/complaint_model.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/group_setting_view.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/utils/complaint_dialog.dart';
import 'package:provider/provider.dart';

mixin GroupSettingViewMixin on State<GroupSettingView> {
  showScaffoldMessenger(String message, Color color);
  showMemberDialog(UserModel2 user, String myUserId, ChatGroupModel group);
  Future<void> leaveGroup(int groupId) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    if (!mounted) return;
    var response = await context
        .read<GroupSettingViewmodel>()
        .leaveGroup(DataObjects.joinGroup(groupId, userId!));
    if (response.statusCode == 200) {
      if (!mounted) return;
      await context.read<MyGroupsViewmodel>().fetchMyChatGroups();
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      await context.read<ChatGroupsViewmodel>().fetchChatGropsList();
      if (!mounted) return;
      context.go('${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}');
    }
  }

  Future<void> shareGroup() async {}

  Future<void> reportUserOrGroup(
      bool isUserReport, String reportedUserOrGroupId) async {
    var list = Provider.of<GroupSettingViewmodel>(context, listen: false).list;
    var selectedID = await ComplaintDialog.show(
        context: context, reasons: list, title: "Grubu Şikayet Nedenini");
    String? complainingUser =
        await LocalStorageImpl().getValue<String>("user_id");

    var newComplaint = ComplaintModel(
        complainingUserId: complainingUser,
        complaintReasonId: selectedID,
        reportedChatGroupId: int.tryParse(reportedUserOrGroupId),
        reportedUserId: reportedUserOrGroupId);
    try {
      if (!mounted) return;
      Response response;
      if (isUserReport) {
        response = await context
            .read<GroupSettingViewmodel>()
            .addComplaintUser(newComplaint.toJson());
      } else {
        response = await context
            .read<GroupSettingViewmodel>()
            .addComplaintChatGroup(newComplaint.toJson());
      }

      if (response.statusCode == 200) {
        showScaffoldMessenger(
            '${isUserReport ? "Kullanıcı" : "Grup"} şikayet edildi.',
            Colors.orangeAccent);
      } else {
        showScaffoldMessenger(
            '${isUserReport ? "Kullanıcı" : "Grup"} şikayet edilirken bir hata ile karşılaşıldı.',
            Colors.red);
      }
    } catch (ex) {
      showScaffoldMessenger(
          '${isUserReport ? "Kullanıcı" : "Grup"} şikayet edilirken bir hata ile karşılaşıldı.',
          Colors.red);
      log("options-reportgroup", error: ex.toString());
    }
  }

  Future<void> viewProfile(UserModel2 user, BuildContext context, isMe) async {
    if (isMe) {
      context.go(AppRoutes.profilePage);
    } else {
      context.push(
          '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}/${AppRoutes.messagePage}/${AppRoutes.groupSettingPage}/${AppRoutes.otherUserProfile}',
          extra: user.userId);
    }
  }

  Future<void> removeUser(
      int groupId, String adminId, String removedUserId) async {
    var data = DataObjects.removeUSer(groupId, adminId, removedUserId);
    var response = await context.read<GroupSettingViewmodel>().removeUser(data);
    if (response.statusCode == 200) {
      if (!mounted) return;
      await context.read<GroupSettingViewmodel>().fetchGroupData(groupId);
      showScaffoldMessenger("Kullanıcı Çıkarıldı", Colors.green);
    } else {
      showScaffoldMessenger(
          "Kullanıcı çıkarılırken bir hata oluştu", Colors.red);
    }
  }

  Future<void> sendMessage(UserModel2 user) async {
    try {
      var response = await context
          .read<GroupSettingViewmodel>()
          .startPrivateConversation(user.userId!);
      if (response.statusCode == 200) {
        final Map<String, dynamic> args = {
          "userId": user.userId!,
          "connectionId": response.data["connectionId"],
          "privateConversationId": response.data["privateConversationId"]
        };
        if (!mounted) return;
        context.push(
            '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}/${AppRoutes.messagePage}/${AppRoutes.groupSettingPage}/${AppRoutes.privateChatPage}',
            extra: args);
      }
    } catch (e) {
      log("GrupSettingPage_to_private_chat_page", error: e.toString());
      showScaffoldMessenger('Sohbet başlatılamadı', Colors.red);
    }
  }
}
