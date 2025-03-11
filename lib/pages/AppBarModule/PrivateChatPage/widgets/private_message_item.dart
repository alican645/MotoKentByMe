
import 'package:flutter/material.dart';
import 'package:moto_kent/models/private_message_model.dart';
import 'package:moto_kent/utils/utils.dart';

class PrivateMessageItem extends StatelessWidget {
  final PrivateMessageModel privateMessageModel;
  final String receiverUserId;
  final String myFullName;
  final String otherUserFullName;
  const PrivateMessageItem({
    super.key,
    required this.privateMessageModel,
    required this.receiverUserId,
    required this.myFullName,
    required this.otherUserFullName

  });


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: receiverUserId==privateMessageModel.senderId?Alignment.centerLeft:Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width / 1.5,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( receiverUserId==privateMessageModel.senderId?otherUserFullName:myFullName
            ),
            Text(privateMessageModel.messageContent!),
            Align(
              alignment: Alignment.centerRight,
              child: Text(Utils.getCurrentTime(privateMessageModel.createdDate!)),
            )
          ],
        ),
      ),
    );
  }
}