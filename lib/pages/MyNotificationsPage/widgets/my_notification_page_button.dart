


import 'package:flutter/material.dart';

class MyNotificationsPageButton extends StatelessWidget {
  const MyNotificationsPageButton(
      {super.key,
      required this.color,
      required this.onPressed,
      required this.icon});
  final Color color;
  final VoidCallback onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ));
  }
}
