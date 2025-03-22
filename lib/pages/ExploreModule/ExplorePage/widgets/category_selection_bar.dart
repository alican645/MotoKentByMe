import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/widgets/filter_dialog.dart';
import 'package:provider/provider.dart';

class CategorySelectionBar extends StatelessWidget {
  const CategorySelectionBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xfff48a34),
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Consumer<ExploreViewmodel>(
          builder: (context, value, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  context.go(
                      '${AppRoutes.explorePage}/${AppRoutes.postSharingView}');
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 36,
                      color: Colors.white,
                    ),
                    Text(
                      "Oluştur",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => FilterDialog(),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        "Filtrele",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
