import 'package:flutter/material.dart';

class AnketIlanAddButton extends StatelessWidget {
  const AnketIlanAddButton(
      {super.key, required VoidCallback onPressed, required String text})
      : _onPressed = onPressed,
        _text = text;

  final VoidCallback _onPressed;
  final String _text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        style: const ButtonStyle(),
        onPressed: _onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(_text),
        ),
      ),
    );
  }
}
