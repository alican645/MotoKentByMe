

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_model.dart';

class ChatGroupItem extends StatelessWidget {

  const ChatGroupItem({
    super.key,
    required this.chatGroupModel,
    required this.onPressed,

  });
  final ChatGroupModel chatGroupModel;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(90),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 30,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.network('${ApiConstants.baseUrl}${chatGroupModel.groupIconPath}')),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      chatGroupModel.name!,
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          chatGroupModel.groupDescription!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              //"${chatGroupModel.membersNumber}/${chatGroupModel.maxMembersNumber}",
                              "${chatGroupModel.currentMemberCount}/${chatGroupModel.maxMemberCount}",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}