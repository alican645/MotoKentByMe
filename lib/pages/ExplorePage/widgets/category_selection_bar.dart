


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/ExplorePage/widgets/button.dart';
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
                  context.go("/post_screen_page/post_sharing_view");
                },
                child: const Icon(
                  Icons.add_circle,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              Visibility(
                visible: value.showNewPostBtn,
                child: GestureDetector(
                  onTap: () async {
                    value.resetPagination();
                    await value.fetchPostList();
                    value.dontShowNewPostBtnFun();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child:  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text("Yeni Göderileri Gör"),
                    ),
                  ),
                ),
              ),
              Button(list: value.postCategoryModelList),
            ],
          ),
        ),
      ),
    );
  }
}

