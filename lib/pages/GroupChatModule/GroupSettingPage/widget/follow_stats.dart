
  import 'package:flutter/material.dart';
import 'package:moto_kent/models/user_model.dart';



  class FollowStatColumn extends StatelessWidget {
    final UserModel2 user;
    
  const FollowStatColumn({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, 
      children: [
       StatColumn(title: "Takipçi", count: user.followerCount!),
       StatColumn(title: "Takip", count: user.followingCount!),
      ],
    );
  }
}





class StatColumn extends StatelessWidget {
  final String title;
  final int count;
  const StatColumn({super.key,required this.title,required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Text(count.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

