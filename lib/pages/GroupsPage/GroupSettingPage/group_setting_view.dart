import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_error_widget.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/models/complaint_model.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/group_header_widget.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/member_card_item.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/options_widget.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/show_member_dialog.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/utils/complaint_dialog.dart';
import 'package:provider/provider.dart';

class GroupSettingView extends StatefulWidget {
  final int? groupId;
  const GroupSettingView({super.key, this.groupId});

  @override
  State<GroupSettingView> createState() => _GroupSettingViewState();
}

class _GroupSettingViewState extends State<GroupSettingView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<GroupSettingViewmodel>();
    final groupIdd = widget.groupId as int;
    final mediaQuery = MediaQuery.of(context);

    return FutureBuilder(
      future: viewModel.initialize(groupIdd),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadingWidget();
        }

        if (snapshot.hasError) {
          return CustomErrorWidget(
            errorMessage: 'Grup bilgileri yüklenemedi: ${snapshot.error}',
            onRetry: () {
              viewModel.initialize(groupIdd);
            },
          );
        }

        ChatGroupModel groupData = snapshot.data!["chatGroupModel"]!;
        final myUserId = snapshot.data!["myUserId"]!;
        return Scaffold(
          appBar: CustomAppBar(
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.02,
                  vertical: 8,
                ),
                child: OptionsWidget(
                  amIAdmin: groupData.amIAdmin!,
                  onLeaveGroup: () async {
                    await leaveGroup(groupData.chatGroupId!);
                  },
                  onReportGroup: () async {
                    await _reportUserOrGroup(false,groupData.chatGroupId!.toString());
                  },
                  onShareGroup: () async {
                    await shareGroup();
                  },
                  goJoinGroupRequestPage: () async {
                     context.push("/join_group_request_page",extra:groupIdd );
                  },
                ),
              )
            ],
          ),
          body: Column(
            children: [
              GroupHeaderWidget(
                groupData: groupData,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemCount: groupData.users!.length,
                    separatorBuilder: (ctx, i) =>
                        Divider(height: 1, color: Colors.grey[400]),
                    itemBuilder: (context, index) {
                      UserModel user = groupData.users![index];

                      return MemberCardItem(
                          key: ValueKey(user.userId),
                          isAdmin: groupData.groupAdminUserId == user.userId,
                          userModel: user,
                          onPressed: () => ShowMemberDialog.show(
                                contextt: context,
                                isMe: user.userId == myUserId,
                                user: user,
                                onPressedReport: () async {
                                  await _reportUserOrGroup(true,user.userId!);
                                },
                                onPressedSendMessage: () async {
                                  await _sendMessage(user, context);
                                },
                                onPressedViewProfile: () async {
                                  await _viewProfile(
                                    user,
                                    context,
                                    user.userId == myUserId,
                                  );
                                },
                                
                              ));
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> leaveGroup(int groupId) async {
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");
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
      Navigator.popUntil(
          context, (route) => route.settings.name == "my_groups");
    }
  }

  Future<void> shareGroup() async {}

  Future<void> _reportUserOrGroup(
      bool isUserReport, String reportedUserOrGroupId) async {
    var list = Provider.of<GroupSettingViewmodel>(context, listen: false).list;
    var selectedID =
        await ComplaintDialog.show(context: context, reasons: list);
    String? complainingUser =
        await SharedPreferencesHelper().getValue<String>("user_id");

    var newComplaint = ComplaintModel(
        complainingUserId: complainingUser,
        complaintReasonId: selectedID,
        reportedChatGroupId: int.tryParse(reportedUserOrGroupId),
        reportedUserId: reportedUserOrGroupId);
    try {
      if (!mounted) return;
      var response = isUserReport
          ? await context
              .read<GroupSettingViewmodel>()
              .addComplaintUser(newComplaint.toJson())
          : await context
              .read<GroupSettingViewmodel>()
              .addComplaintChatGroup(newComplaint.toJson());

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text('${isUserReport ? "Kullanıcı" : "Grup"} şikayet edildi.')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('${isUserReport ? "Kullanıcı" : "Grup"} şikayet edilirken bir hata ile karşılaşıldı.')),
        );
      }
    } catch (ex) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('${isUserReport ? "Kullanıcı" : "Grup"} şikayet edilirken bir hata ile karşılaşıldı.')),
        );
      log("options-reportgroup", error: ex.toString());
    }
  }


  Future<void> _viewProfile(UserModel user, BuildContext context, isMe) async {
    if (isMe) {
      context.go(AppRoutes.profilePage);
    } else {
      context.push(AppRoutes.otherUserProfile, extra: user.userId);
    }
  }

  Future<void> _sendMessage(UserModel user, BuildContext context) async {
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
        context.push("/private_chat_page", extra: args);
      }
    } catch (e) {
      log("GrupSettingPage_to_private_chat_page", error: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sohbet başlatılamadı'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
