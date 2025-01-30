
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';



class PostDetatilProfileWidget extends StatelessWidget {
  const PostDetatilProfileWidget(
      {super.key,
        required this.photoPath,
        required this.postUserId,
        });

  final String postUserId;

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? accountUserId=await SharedPreferencesHelper().getValue<String>("user_id");
        if(postUserId==accountUserId){
          context.go("/profile_page");
        }else{
          context.push("/other_user_profile",
              extra: postUserId);
        }

      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300,width: 1.5),
          borderRadius: BorderRadius.circular(16)
        ),
        height: 130,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(photoPath),
        ),
      ),
    );
  }
}