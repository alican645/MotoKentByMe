import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {

  final Function()? onTap;
  final String text; // Buton metni için yeni parametre

  MyButton({super.key, required this.onTap, required this.text});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(

        onTap: widget.onTap,
        child: Container(
          width: MediaQuery.sizeOf(context).width/2,
          height: MediaQuery.sizeOf(context).height/20,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.text, // Metin burada dinamik olarak ayarlanıyor
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ),
        ),
      ),
    );
  }
}
