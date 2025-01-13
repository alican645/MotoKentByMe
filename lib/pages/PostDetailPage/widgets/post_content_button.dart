

import 'package:flutter/material.dart';

class PostContentButton extends StatelessWidget {
  const PostContentButton(
      {super.key,
        required this.content,
        required this.iconData,
        this.count,
        this.onPressed});
  final String content;
  final IconData iconData;
  final VoidCallback? onPressed;
  final int? count;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(iconData),
          Text(content),
          count!=null?Text(count.toString()):SizedBox()
        ],
      ),
    );
  }
}