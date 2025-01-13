

import 'package:flutter/material.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:provider/provider.dart';

class ChoiceCategoryItem extends StatelessWidget {
  final int categoryId;
  final String iconPath;
  final Color color;
  final String categoryName;
  const ChoiceCategoryItem(
      {super.key,
        required this.categoryId,
        required this.iconPath,
        required this.color,
        required this.categoryName});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            context
                .read<ExploreViewmodel>()
                .changeCategory(categoryId); // Kategori değişimi
            await context.read<ExploreViewmodel>().fetchAllOrCategoryId();
          },
          child: Container(
            height: 50,
            color: color,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(categoryName),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(iconPath),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}