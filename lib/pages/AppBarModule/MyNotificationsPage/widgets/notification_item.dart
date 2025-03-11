import 'package:flutter/material.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/models/notification_model.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/widgets/my_notification_page_button.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.model,
    this.acceptUser,
    this.goUserProfile,
    this.goChatGroup,
    this.rejectUser,
    this.okey
  });

  final NotificationModel model;
  final VoidCallback? acceptUser;
  final VoidCallback? rejectUser;
  final VoidCallback? goUserProfile;
  final VoidCallback? goChatGroup;
  final VoidCallback? okey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: model.isRead! ? Colors.grey[200] : Colors.orange[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.content!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final buttonConfigs = {
      NotificationTypeEnum.groupJoinRequest.index: [
        _ButtonConfig(Colors.green, acceptUser, Icons.check),
        _ButtonConfig(Colors.red, rejectUser, Icons.close),
        _ButtonConfig(Colors.orange, goUserProfile, Icons.remove_red_eye),
      ],
      NotificationTypeEnum.groupChatMessage.index: [
        _ButtonConfig(Colors.green, goChatGroup, Icons.arrow_forward),
      ],
      NotificationTypeEnum.groupJoinAcceptMessage.index: [
        _ButtonConfig(Colors.green, okey, Icons.remove),
      ],
      NotificationTypeEnum.groupJoinRejectMessage.index: [
        _ButtonConfig(Colors.green, okey, Icons.remove),
      ],
      NotificationTypeEnum.postLike.index: [
        _ButtonConfig(Colors.green, okey, Icons.remove),
      ],
      NotificationTypeEnum.postComment.index: [
        _ButtonConfig(Colors.green, okey, Icons.remove),
      ],
    };

    final buttons = buttonConfigs[model.type] ?? [];
    if (buttons.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: buttons
          .map(
            (config) => Padding(
          padding: const EdgeInsets.only(left: 5),
          child: MyNotificationsPageButton(
            color: config.color,
            onPressed: config.onPressed!,
            icon: config.icon,
          ),
        ),
      )
          .toList(),
    );
  }
}

class _ButtonConfig {
  final Color color;
  final VoidCallback? onPressed;
  final IconData icon;

  _ButtonConfig(this.color, this.onPressed, this.icon);
}