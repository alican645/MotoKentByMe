

import 'package:flutter/material.dart';
import 'package:moto_kent/pages/ExplorePage/widgets/list_items.dart';
import 'package:popover/popover.dart';

class Button extends StatelessWidget {
  final List<dynamic> list;
  const Button({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Row(
        children: [
          Text(
            "Kategori Seç",
            style: TextStyle(color: Colors.white),
          ),
          Icon(
            Icons.arrow_drop_down_circle,
            size: 36,
            color: Colors.white,
          )
        ],
      ),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => ListItems(
            list: list,
          ),
          direction: PopoverDirection.bottom,
          backgroundColor: Colors.white,
          width: 200,
          height: 400,
          arrowHeight: 15,
          arrowWidth: 30,
          arrowDxOffset: 1000,
        );
      },
    );
  }
}