

import 'package:flutter/material.dart';
import 'package:moto_kent/App/app_theme.dart';

class PostDetailRouteButton extends StatelessWidget {
  const PostDetailRouteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: AppTheme.themeData.primaryColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Takip Et"),
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

