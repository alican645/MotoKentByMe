import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
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

              const CategoryDropdown()
            ],
          ),
        ),
      ),
    );
  }
}






class CategoryDropdown extends StatelessWidget {


  const CategoryDropdown({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Flexible(
      child: SizedBox(
        width: 200,
        child: Consumer<ExploreViewmodel>(builder: (context, viewmodel, child) =>
           DropdownButtonFormField2<String>(
            isExpanded: true,
            hint: Text("Kategoriler"),
            value: viewmodel.selectedCategoryName,
            items: viewmodel.postCategoryModelList.map(
                  (e) {
                return DropdownMenuItem<String>(

                  onTap: () async {

                    viewmodel
                        .changeCategory(e.id); // Kategori değişimi
                    await viewmodel.fetchAllOrCategoryId();
                  },
                  value: e.categoryName,
                  child: Row(
                    children: [
                      // İkonu internetten çekiyoruz
                      if (e.photoPath != null) Flexible(
                        child: Image.network(
                          "${ApiConstants.baseUrl}/${e.photoPath!}",
                          width: 24,
                          height: 24,
                          //color: Colors.white,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 24),
                        ),
                      ) else Icon(Icons.category, size: 24),
                      const SizedBox(width: 8),
                      Text(e.categoryName ?? ''),
                    ],
                  ),
                );
              },
            ).toList(),
            onChanged: (value) async {
              if (value != null) {
                final selected = viewmodel.postCategoryModelList.firstWhere((e) => e.categoryName == value);

                viewmodel
                    .changeCategory(selected.id); // Kategori değişimi
                await viewmodel.fetchAllOrCategoryId();
              }
            },
            decoration: InputDecoration(
              iconColor: Colors.white70,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),

              ),
              contentPadding: const EdgeInsets.only(left: 60),
              enabledBorder: InputBorder.none

            ),
          ),
        ),
      ),
    );
  }
}
