import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 120,
          width: 120,
          child: Lottie.asset('assets/animation/lottie2.json')),
    );
  }
}
