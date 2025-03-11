import 'package:flutter/material.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/widget/action_button.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/widget/follow_stats.dart';

class ShowMemberDialog {
  static Future<void> show(
      {required BuildContext contextt,
      required UserModel2 user,
      required bool isMe,
      required VoidCallback onPressedReport,
      required VoidCallback onPressedSendMessage,
      required VoidCallback onPressedViewProfile}) async {
    showDialog<void>(
      context: contextt,
      builder: (context) => AlertDialog(
        title: Center(child: Text(user.fullName!)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FollowStatColumn(user: user),
              const SizedBox(height: 16),
              Text(user.bio ?? "Kullanıcı biyografisi bulunmuyor",
                  style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
        actions: [
          isMe
              ? const SizedBox()
              : ActionButton(
                  context: context,
                  text: "Şikayet Et",
                  icon: Icons.report,
                  onPressed: () async {

                     onPressedReport();
                  },
                ),
          ActionButton(
            text: "Profili Görüntüle",
            icon: Icons.person,
            onPressed: () async {
              onPressedViewProfile();
            },
            context: context,
          ),
          isMe
              ? const SizedBox()
              : ActionButton(
                  text: "Mesaj At",
                  icon: Icons.message,
                  onPressed: () async {
                    onPressedSendMessage();
                  },
                  context: context,
                ),
        ],
      ),
    );
  }
}
