import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/private_conversation_model.dart';
import 'package:moto_kent/utils/utils.dart';

class PrivateConversationItem extends StatelessWidget {
  const PrivateConversationItem({
    super.key,
    required this.model,
    required this.onTap
  });
  final PrivateConversationModel model;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 2),
        decoration: BoxDecoration(
          color:Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                radius: 20,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.network(
                      "${ApiConstants.baseUrl}/${model.profilePhotoPath}",
                      scale: 5,
                    )),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    model.fullName!,
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          model.lastMessage!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                        ),
                      ),
                      Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              Utils.getCurrentTime(model.lastMessageTime!),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall,
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