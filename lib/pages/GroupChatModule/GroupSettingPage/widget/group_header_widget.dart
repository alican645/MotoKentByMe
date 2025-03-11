




import 'package:flutter/material.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/widget/group_icon_widget.dart';

class GroupHeaderWidget extends StatelessWidget {
  final ChatGroupModel groupData;
  const GroupHeaderWidget({super.key,required this.groupData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GroupIconWidget(iconPath: groupData.groupImagePath!),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "${groupData.name!} (${groupData.currentMemberCount}/${groupData.maxMemberCount})",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}