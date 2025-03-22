import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostContentButton extends StatelessWidget {
  const PostContentButton(
      {super.key,
      required this.content,
      this.iconData,
      this.count,
      this.svgPath,
      required this.color,
      this.onPressed});
  final String content;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final int? count;
  final String? svgPath;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          iconData == null
              ? SvgPicture.asset(
                  svgPath!,
                  height: 36,
                  width: 36,
                  color: Colors.orange,
                )
              : Icon(
                  iconData,
                  size: 30,
                  color: color,
                ),
          Text(content),
          count != null ? Text(count.toString()) : SizedBox()
        ],
      ),
    );
  }
}
