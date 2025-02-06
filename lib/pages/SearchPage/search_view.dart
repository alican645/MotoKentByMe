import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/user_search_item_model.dart';
import 'package:moto_kent/pages/SearchPage/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<SearchViewmodel>().clearSearchItemList();
      },
      child: Scaffold(
          appBar:  CustomAppBar(title: "Kullanıcı Arayın...",),
          body: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              hintText: "Search..."),
                          onChanged: (value) {
                            context.read<SearchViewmodel>().fetchUsers(value);
                          },
                        ),
                      ),
                      const Icon(Icons.search)
                    ]
                  ),
                ),
              ),
              Flexible(
                child: Consumer<SearchViewmodel>(
                  builder: (context, value, child) => ListView.builder(
                    itemCount: value.searchItemList.length,
                    itemBuilder: (context, index) => SearchUserItem(
                      onPressed: () {
                        context.push("/other_user_profile",
                            extra: value.searchItemList[index].id);
                      },
                      userSearchItemModel: value.searchItemList[index],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class SearchUserItem extends StatelessWidget {
  const SearchUserItem({
    super.key,
    required this.userSearchItemModel,
    required this.onPressed,
  });
  final UserSearchItemModel userSearchItemModel;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(90),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: NetworkImage(
                      '${ApiConstants.baseUrl}/${userSearchItemModel.profilePhotoPath}'),
                  radius: 30,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        userSearchItemModel.fullName!,
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4.0),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
