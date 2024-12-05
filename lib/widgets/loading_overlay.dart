import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading; // Spinner gösterimi için
  final Widget child;   // Asıl içerik widget'ı

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // Ana içerik
        if (isLoading) // Eğer isLoading true ise spinner göster
          Container(
            color: Colors.orangeAccent,
            child:  Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
