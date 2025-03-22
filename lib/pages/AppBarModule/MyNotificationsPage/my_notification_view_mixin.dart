import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/group_join_request_model.dart';
import 'package:moto_kent/models/notification_model.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_view.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_viewmodel.dart';
import 'package:provider/provider.dart';

mixin MyNotificationsViewMixin on State<MyNotificationsView> {
  void showScaffoldMessenger(String message, Color color);

  Future<Response> operationDone(
    int id,
    int index,
  ) async {
    var data = {"notificationId": id};
    var response = await context
        .read<MyNotificationsViewmodel>()
        .operationDone(data, index);

    return response;
  }

  void goUserProfilePage(String userId) {
    context.push(
        '${AppRoutes.explorePage}/${AppRoutes.myNotificationsPage}/${AppRoutes.otherUserProfile}',
        extra: userId);
  }

  void goChatGroup(NotificationModel notificationModel) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    String? username =
        await LocalStorageImpl().getValue<String>("user_full_name");
    if(notificationModel.type==1){
      Map<String, dynamic> object = {
        "userId": userId!,
        "groupId": notificationModel.payload!.chatGroupId!,
        "userName": username!,
        "groupName": notificationModel.payload!.groupName!
      };
      if(!mounted) return;
      context.push(
          '${AppRoutes.explorePage}/${AppRoutes.myNotificationsPage}/${AppRoutes.messagePage}',
          extra: object);
    }if(notificationModel.type==0){
      final Map<String, dynamic> args = {
        "userId": notificationModel.payload!.userId,
        "connectionId": notificationModel.payload!.connectionId,
        "privateConversationId": notificationModel.payload!.privateConversationId
      };
      if (!mounted) return;
      context.push(
          '${AppRoutes.explorePage}/${AppRoutes.myPrivateMessagesPage}/${AppRoutes.privateChatPage}',
          extra: args);
    }

  }

  Future<void> acceptUser(NotificationModel notificationModel,
      BuildContext context, int index) async {
    var model = GroupJoinRequestModel(
        notificationId: notificationModel.id,
        userId: notificationModel.payload!.userId,
        chatGroupId: notificationModel.payload!.chatGroupId,
        isAccept: true);
    try {
      var response = await context
          .read<MyNotificationsViewmodel>()
          .acceptOrReject(model.toJson(), index);
      if (response.statusCode == 200) {
        showScaffoldMessenger("Kullanıcı kabul edildi.", Colors.green);
      }
    } catch (e) {
      log("acceptUser", error: e.toString());
    }
  }

  Future<void> rejectUser(NotificationModel notificationModel,
      BuildContext context, int index) async {
    var model = GroupJoinRequestModel(
        notificationId: notificationModel.id,
        userId: notificationModel.payload!.userId,
        chatGroupId: notificationModel.payload!.chatGroupId,
        isAccept: false);
    try {
      var response = await context
          .read<MyNotificationsViewmodel>()
          .acceptOrReject(model.toJson(), index);
      if (response.statusCode == 200) {
        showScaffoldMessenger("Kullanıcı reddedildi.", Colors.red);
      }
    } catch (e) {
      log("rejectUser", error: e.toString());
    }
  }

  Future<void> operationDoneForOkey(int id, int index) async {
    operationDone(id, index);
    var response = await operationDone(
      id,
      index,
    );
    if (response.statusCode == 200) {
      var indexx = index;
      if (!mounted) return;
      context.read<MyNotificationsViewmodel>().removeNotification(indexx);
    }
  }

  Future<void> operationDoneForGoChatGroupOrUserConversation(
      int id, int index, NotificationModel notificationModel) async {
    var response = await operationDone(
      id,
      index,
    );
    if (response.statusCode == 200) {
      var indexx = index;
      goChatGroup(notificationModel);
      if (!mounted) return;
      context.read<MyNotificationsViewmodel>().removeNotification(indexx);
    }
  }
}
