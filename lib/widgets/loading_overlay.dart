import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class LoadingOverlay extends StatelessWidget {
  final bool isLoading; // Spinner gösterimi için
  final Widget child;   // Asıl içerik widget'ı

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?child:Container(
        color:  const Color(0x00000000).withOpacity(0.5),
        child:  Center(
          child: SizedBox(
              height: 120,
              width: 120,
              child: Lottie.asset('assets/animation/lottie2.json')),
        ),
      ),
    );
  }
}
