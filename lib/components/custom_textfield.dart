
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController controller,
    required this.hintText,
     this.validationText,
    this.maxLength,
    this.onTap
  }) : _controller = controller;

  final TextEditingController _controller;
  final String hintText;
  final String? validationText;
  final int? maxLength;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      maxLength: maxLength,
      controller: _controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validationText;
        }
        return null;
      },
    );
  }
}