import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/widgets/post_item.dart';
import 'package:moto_kent/pages/ProfileModule/MyPostPage/my_post_viewmodel.dart';
import 'package:provider/provider.dart';

class MyPostView extends StatefulWidget {
  const MyPostView({super.key});

  @override
  State<MyPostView> createState() => _MyPostViewState();
}

class _MyPostViewState extends State<MyPostView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<MyPostViewmodel>().fetchFavoritePostList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Postlarım",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<MyPostViewmodel>(
          builder: (context, viewModel, child) {
            if (viewModel.posts.isEmpty && viewModel.isLoading) {
              return const Center(child: CustomLoadingWidget());
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: viewModel.posts.length + (viewModel.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < viewModel.posts.length) {
                  final post = viewModel.posts[index];
                  return PostItem(
                    postModel: post,
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: CustomLoadingWidget(),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
