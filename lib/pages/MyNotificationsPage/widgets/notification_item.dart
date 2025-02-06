

import 'package:flutter/material.dart';
import 'package:moto_kent/models/notification_model.dart';
import 'package:moto_kent/pages/MyNotificationsPage/widgets/my_notification_page_button.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem(
      {super.key,
      required this.model,
       this.acceptUser,
       this.goUserProfile,
       this.goChatGroup,
       this.rejectUser});

  final NotificationModel model;
  final VoidCallback? acceptUser;
  final VoidCallback? rejectUser;
  final VoidCallback? goUserProfile;
  final VoidCallback? goChatGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: model.isRead! ?Colors.grey[200]:Colors.orange[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.content!,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start ,
            ),
            model.type!=1 ?Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 MyNotificationsPageButton(
                    color: Colors.green, onPressed: acceptUser!, icon: Icons.check),
                    SizedBox(width: 5,),
                MyNotificationsPageButton(
                    color: Colors.red, onPressed: rejectUser!, icon: Icons.close),
                    SizedBox(width: 5,),
               MyNotificationsPageButton(
                    color: Colors.orange,
                    onPressed: goUserProfile!,
                    icon: Icons.remove_red_eye),
              ],
            ):Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 MyNotificationsPageButton(
                    color: Colors.green, onPressed: goChatGroup!, icon: Icons.arrow_forward  ),
                    SizedBox(width: 5,),
               
              ],
            )
          ],
        ),
      ),
    );
  }
}
