import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';

class PostDetailPageButton extends StatelessWidget
{
  final String content;
  final VoidCallback onPressed;
  const PostDetailPageButton(
      {super.key, required this.content, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: AppTheme.themeData.primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(content,style: const TextStyle(
                          color: Colors.white
                      ),)
                    ],),
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.white),
                    child: const Icon(Icons.chevron_right))
              ],
            ),
          ),
        ));
  }
}