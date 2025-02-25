import 'package:flutter/material.dart';

class CustomButton22 extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final Color splashColor;
  final Color hoverColor;
  final EdgeInsets padding;
  final double elevation;
  final Duration animationDuration;

  const CustomButton22({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.splashColor = Colors.blueAccent,
    this.hoverColor = Colors.lightBlue,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    this.elevation = 2.0,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _CustomButton22State createState() => _CustomButton22State();
}

class _CustomButton22State extends State<CustomButton22> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerDown: (_) => setState(() => _isPressed = true),
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            if (!_isPressed)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: widget.elevation,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            splashColor: widget.splashColor,
            hoverColor: widget.hoverColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Padding(
              padding: widget.padding,
              child: AnimatedScale(
                duration: widget.animationDuration,
                scale: _isPressed ? 0.95 : 1.0,
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}