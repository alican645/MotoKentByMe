
import 'package:flutter/material.dart';

class ShowRatingWidget extends StatelessWidget {
  final int? rating;
  const ShowRatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          rating!,
              (index) => const Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        )
      ],
    );
  }
}
