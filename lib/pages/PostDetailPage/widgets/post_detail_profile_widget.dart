
import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';



class PostDetatilProfileWidget extends StatelessWidget {
  const PostDetatilProfileWidget({super.key, required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(photoPath),
      ),
    );
  }
}