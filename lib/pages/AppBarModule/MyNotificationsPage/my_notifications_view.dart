import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/group_join_request_model.dart';
import 'package:moto_kent/models/notification_model.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/widgets/notification_item.dart';
import 'package:provider/provider.dart';

class MyNotificationsView extends StatefulWidget {
  const MyNotificationsView({super.key});

  @override
  State<MyNotificationsView> createState() => _MyNotificationsViewState();
}

class _MyNotificationsViewState extends State<MyNotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<MyNotificationsViewmodel>().fetchList(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Bildirimlerim",
      ),
      body: Consumer<MyNotificationsViewmodel>(
        builder: (context, value, child) {
          if (value.isLoading == false) {
            return const CustomLoadingWidget();
          }
          return ListView.builder(
              itemCount: value.list.length,
              itemBuilder: (context, index) => NotificationItem(
                    acceptUser: () async {
                      await acceptUser(value.list[index], context, index);
                    },
                    rejectUser: () async {
                      await rejectUser(value.list[index], context, index);
                    },
                    goUserProfile: () {
                      goUserProfilePage(value.list[index].payload!.userId!);
                    },
                    goChatGroup: () {
                      goChatGroup(value.list[index]);
                    },
                    okey: () {
                      operationDone(value.list[index].id!, index);
                    },
                    model: value.list[index],
                  ));
        },
      ),
    );
  }

  Future<void> operationDone(int id, int index) async {
    var data = {"notificationId": id};
    await context.read<MyNotificationsViewmodel>().operationDone(data, index);
  }

  void goUserProfilePage(String userId) {
    context.push("/other_user_profile", extra: userId);
  }

  void goChatGroup(NotificationModel notificationModel) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    String? username =
        await LocalStorageImpl().getValue<String>("userfullname");
    Map<String, dynamic> object = {
      "userId": userId!,
      "groupId": notificationModel.payload!.chatGroupId!,
      "userName": username!,
      "groupName": notificationModel.payload!.groupName!
    };
    context.push(AppRoutes.messagePage, extra: object);
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Kullanıcı kabul edildi.")));
      }
    } catch (e) {
      log("acceptUser", error: e.toString());
    }
  }

  Future<void> rejectUser(NotificationModel notificationModel,
      BuildContext context, int index) async {
    var model = GroupJoinRequestModel(
        userId: notificationModel.payload!.userId,
        chatGroupId: notificationModel.payload!.chatGroupId,
        isAccept: false);
    try {
      var response = await context
          .read<MyNotificationsViewmodel>()
          .acceptOrReject(model.toJson(), index);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Kullanıcı reddedildi.")));
      }
    } catch (e) {
      log("rejectUser", error: e.toString());
    }
  }
}
