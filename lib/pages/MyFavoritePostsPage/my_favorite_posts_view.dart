import 'package:flutter/material.dart';
import 'package:moto_kent/main.dart';
import 'package:moto_kent/pages/ExplorePage/widgets/post_item.dart';
import 'package:moto_kent/pages/MyFavoritePostsPage/my_favorite_posts_viewmodel.dart';
import 'package:provider/provider.dart';

class MyFavoritePostsView extends StatelessWidget {
  const MyFavoritePostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorilerim"),),
      body: FutureBuilder(
        future: context.read<MyFavoritePostsViewmodel>().fetchMyFavoritePosts(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                PostItem(postModel: snapshot.data![index]),
          );
        },
      ),
    );
  }
}
