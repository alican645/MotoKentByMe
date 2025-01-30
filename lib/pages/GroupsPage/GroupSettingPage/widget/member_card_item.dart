

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/user_model.dart';

class MemberCardItem extends StatelessWidget {
  const MemberCardItem({
    super.key,
    required this.userModel,
    required this.onPressed,
    required this.isAdmin,
  });
  final UserModel userModel;
  final VoidCallback onPressed;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: isAdmin ? Colors.orange[100] : Colors.grey[300],
            borderRadius: BorderRadius.circular(90),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 30,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        '${ApiConstants.baseUrl}/${userModel.profilePhotoPath}'),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        userModel.fullName!,
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4.0),
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
      ),
    );
  }
}
