
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController controller,
    required this.hintText,
     this.validationText,
    this.maxLength,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String hintText;
  final String? validationText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      maxLength: maxLength,
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
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