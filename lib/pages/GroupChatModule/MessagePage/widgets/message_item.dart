import 'package:flutter/material.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/utils/utils.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(
      {super.key, required this.userId, required this.messageModel});
  final String userId;
  final ChatGroupMessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: userId == messageModel.senderUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width / 1.5,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageModel.senderUserName!,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(messageModel.content!),
            Align(
              alignment: Alignment.centerRight,
              child: Text(Utils.getCurrentTime(messageModel.sentAt!)),
            )
          ],
        ),
      ),
    );
  }
}
