import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';

 class ProfileHeader extends StatelessWidget {
   const ProfileHeader({
    super.key,
    this.onPressed,
    required this.fullName,
    required this.username,
    required this.userProfilePhotoPath,
  });
  final VoidCallback? onPressed;
  final String username;
  final String fullName;
  final String userProfilePhotoPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  height: 150,
                  child: ClipRRect(

                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      '${ApiConstants.baseUrl}/$userProfilePhotoPath',
                      fit: BoxFit.fill,

                    ),
                  ),
                ),
                /*                  CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    '${ApiConstants.baseUrl}/$userProfilePhotoPath'),
                ), */
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      username,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
