


import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String content;

  const BuildButton({super.key,required this.onPressed,
    required this.icon,
    required  this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: icon,
          ),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}