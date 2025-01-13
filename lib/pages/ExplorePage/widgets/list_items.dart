

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/pages/ExplorePage/widgets/choice_category_item.dart';

class ListItems extends StatelessWidget {
  final List<dynamic> list;
  const ListItems({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              itemBuilder: (context, index) => ChoiceCategoryItem(
                  categoryId: list[index].id,
                  iconPath: '${ApiConstants.baseUrl}${list[index].photoPath}',
                  color: Colors.amber[300]!,
                  categoryName: list[index].categoryName!),
            ),
          ),
        ],
      ),
    );
  }
}