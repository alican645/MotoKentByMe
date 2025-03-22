import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notification_view_mixin.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/widgets/notification_item.dart';
import 'package:provider/provider.dart';

class MyNotificationsView extends StatefulWidget {
  const MyNotificationsView({super.key});

  @override
  State<MyNotificationsView> createState() => _MyNotificationsViewState();
}

class _MyNotificationsViewState extends State<MyNotificationsView>
    with MyNotificationsViewMixin {
  @override
  void showScaffoldMessenger(String message, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: color, content: Text(message)));
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<MyNotificationsViewmodel>().fetchList();
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
                    goChatGroup: () async {
                      operationDoneForGoChatGroupOrUserConversation(
                          value.list[index].id!, index, value.list[index]);
                    },
                    okey: () async {
                      await operationDoneForOkey(value.list[index].id!, index);
                    },
                    model: value.list[index],
                  ));
        },
      ),
    );
  }
}
