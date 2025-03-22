import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required TextEditingController controller,
      required this.hintText,
      this.validationText,
      this.maxLength,
      this.onTap,
      this.type,
      this.readOnly = false,
      this.obscureText = false})
      : _controller = controller;

  final TextEditingController _controller;
  final String hintText;
  final String? validationText;
  final int? maxLength;
  final VoidCallback? onTap;
  final TextInputType? type;
  final bool obscureText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      onTap: onTap,
      readOnly: readOnly,
      maxLength: maxLength,
      controller: _controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return validationText;
        }
        return null;
      },
    );
  }
}
