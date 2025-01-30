import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/components/custom_error_widget.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/complaint_model.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/action_button.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/follow_stats.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/group_header_widget.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/member_card_item.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/options_widget.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/widget/show_member_dialog.dart';
import 'package:moto_kent/router.dart';
import 'package:moto_kent/utils/complaint_dialog.dart';
import 'package:provider/provider.dart';

class GroupSettingView extends StatefulWidget {
  final String? groupId;
  const GroupSettingView({super.key, this.groupId});

  @override
  State<GroupSettingView> createState() => _GroupSettingViewState();
}

class _GroupSettingViewState extends State<GroupSettingView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<GroupSettingViewmodel>();
    final groupIdd = widget.groupId as String;
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

        final groupData = snapshot.data!["chatGroupModel"]!;
        final myUserId = snapshot.data!["myUserId"]!;
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.02,
                  vertical: 8,
                ),
                child: OptionsWidget(gorupId: groupData.uniqueId!),
              )
            ],
          ),
          body: Column(
            children: [
              GroupHeaderWidget(groupData:groupData ,),
             Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: groupData.users!.length,
            separatorBuilder: (ctx, i) =>
                Divider(height: 1, color: Colors.grey[400]),
            itemBuilder: (context, index) {
              final user = groupData.users![index];

              return MemberCardItem(
                key: ValueKey(user.userId),
                isAdmin: groupData.groupAdminUserId == user.userId,
                userModel: user,
                onPressed: () =>
                    ShowMemberDialog.show(
                      contextt: context,
                      isMe: user.userId==myUserId,
                      user: user,
                      onPressedReport: () async {
                        
                      },
                      onPressedSendMessage: ()async {
                        _sendMessage(user, context);
                      },
                      onPressedViewProfile: ()async {
                        _viewProfile(user, context, user.userId==myUserId,);
                      },

                    )
              );
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







Future<void> _viewProfile(UserModel user, BuildContext context, isMe) async{
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