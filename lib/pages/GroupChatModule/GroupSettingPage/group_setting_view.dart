import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_bar.dart';

import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/group_setting_view_mixin.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/widget/group_header_widget.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/widget/member_card_item.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/widget/options_widget.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/widget/show_member_dialog.dart';
import 'package:provider/provider.dart';

class GroupSettingView extends StatefulWidget {
  final int? groupId;
  const GroupSettingView({super.key, this.groupId});

  @override
  State<GroupSettingView> createState() => _GroupSettingViewState();
}

class _GroupSettingViewState extends State<GroupSettingView>
    with GroupSettingViewMixin {
  @override
  void initState() {
    super.initState();
    context.read<GroupSettingViewmodel>().fetchGroupData(widget.groupId!);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Consumer<GroupSettingViewmodel>(
      builder: (context, value, child) {
        ChatGroupModel groupData = value.chatGroupModel!;
        final myUserId = value.myUserId;
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
                    await reportUserOrGroup(
                        false, groupData.chatGroupId!.toString());
                  },
                  onShareGroup: () async {
                    await shareGroup();
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
                      UserModel2 user = groupData.users![index];

                      return MemberCardItem(
                          key: ValueKey(user.userId),
                          isAdmin: groupData.groupAdminUserId == user.userId,
                          userModel: user,
                          onPressed: () =>
                              showMemberDialog(user, myUserId!, groupData));
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

  @override
  showScaffoldMessenger(String message, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );

  @override
  showMemberDialog(UserModel2 user, String myUserId, ChatGroupModel group) =>
      ShowMemberDialog.show(
        contextt: context,
        isMe: user.userId == myUserId,
        user: user,
        onPressedReport: () async {
          await reportUserOrGroup(true, user.userId!);
        },
        onPressedSendMessage: () async {
          await sendMessage(user);
        },
        onPressedViewProfile: () async {
          await viewProfile(
            user,
            context,
            user.userId == myUserId,
          );
        },
        onPressedRemoveUser: () async {
          await removeUser(
              group.chatGroupId!, group.groupAdminUserId!, user.userId!);
        },
      );
}
