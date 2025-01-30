import 'package:flutter/material.dart';
  
  


  class ActionButton extends StatelessWidget {
    final String text;
    final IconData icon;
    final VoidCallback onPressed;
    final BuildContext context;
  const ActionButton({super.key,required this.text,required this.icon,required this.onPressed,required this.context});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        onPressed();
      },
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}