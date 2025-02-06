import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/complaint_model.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/MyFavoritePostsPage/my_favorite_posts_viewmodel.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/PostDetailPage/widgets/comments_modal_dialog.dart';
import 'package:moto_kent/pages/PostDetailPage/widgets/post_content_button.dart';

import 'package:moto_kent/utils/complaint_dialog.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:provider/provider.dart';

class PostDetailContentWidget extends StatelessWidget {
  const PostDetailContentWidget({super.key, required this.postModel});
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(45), topLeft: Radius.circular(45)),
          color: Colors.grey[300],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(postModel.postContentTitle!)),
                  SizedBox(
                    height: 75,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                            '${ApiConstants.baseUrl}${postModel.postCategoryPhotoPath}')),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PostContentButton(
                  onPressed: () async {
                    favoritePost(context).then(
                      (value) {
                        resetMyFavoritePage(context);
                      },
                    );
                  },
                  svgPath: postModel.isMyFavorite!
                      ? "assets/svg/favorite.svg"
                      : "assets/svg/not_favorite.svg",
                  content: 'Favorile',
                ),
                PostContentButton(
                  iconData: Icons.send,
                  content: 'Paylaş',
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              const Text("Postu paylaşmak istiyor musunuz?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Hayır")),
                            TextButton(
                                onPressed: () {
                                  sharePost(context);
                                },
                                child: const Text("Evet"))
                          ],
                        );
                      },
                    );
                  },
                ),
                PostContentButton(
                  onPressed: () async {
                    var reasons =
                        Provider.of<PostDetailViewmodel>(context, listen: false)
                            .list;
                    var selectedID = await ComplaintDialog.show(context: context, reasons: reasons);
                    String reportedUser = postModel.userId!;
                    String? complainingUser = await SharedPreferencesHelper()
                        .getValue<String>("user_id");

                    var newComplaint = ComplaintModel(
                        complainingUserId: complainingUser,
                        complaintReasonId: selectedID,
                        reportedUserId: reportedUser);
                    try {
                      var response = await context
                          .read<PostDetailViewmodel>()
                          .addComplaint(newComplaint.toJson());

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: AppTheme.themeData.primaryColor,
                              content: const Text('Kullanıcı şikayet edildi.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Kullanıcı şikayet edilirken bir hata ile karşılaşıldı.')),
                        );
                      }
                    } catch (ex) {
                      log("post_detail_content_add_complaint",error: ex.toString());
                    }
                  },
                  iconData: Icons.report_outlined,
                  content: 'Şikayet Et',
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    SingleChildScrollView(child: Text(postModel.postContent!)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(Utils.formatDateToDayMonthYear(postModel.postDate!)),
                PostContentButton(
                    onPressed: () async {
                      await likePost(context, true);
                    },
                    content: "Like",
                    count: postModel.likes,
                    iconData: Icons.thumb_up_alt),
                PostContentButton(
                    onPressed: () async {
                      await likePost(context, false);
                    },
                    count: postModel.dislikes,
                    content: "Dislike",
                    iconData: Icons.thumb_down_alt),
                PostContentButton(
                    onPressed: () async {
                      showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context, builder: (context) {
                        return CommentsPage(
                          postId: postModel.id!,
                        );
                      },);
                    },
                    count: postModel.commentCount,
                    content: "Comment",
                    iconData: Icons.comment),
                Text(postModel.postLocation!)
              ],
            )
          ],
        ),
      ),
    );
  }

  void resetMyFavoritePage(BuildContext context) {
    context.read<MyFavoritePostsViewmodel>().resetPagination();
  }

  Future<void> favoritePost(BuildContext context) async {
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");
    var data = DataObjects.favoritePost(postModel.id!, userId!);
    await context.read<PostDetailViewmodel>().favoritePost(data);
  }

  Future<void> likePost(BuildContext context, isLike) async {
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");
    await context
        .read<PostDetailViewmodel>()
        .likePost(DataObjects.likePost(postModel.id!, userId!, isLike));
  }

  Future<void> sharePost(BuildContext context) async {
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");

    var postModell = PostModel(
        id: postModel.id,
        postCategoryId: postModel.postCategoryId,
        postContent: postModel.postContent,
        postContentTitle: postModel.postContentTitle,
        postDate: DateTime.now(),
        postLocation: postModel.postLocation,
        userId: postModel.userId,
        sharedUserId: userId);

    var response = await context
        .read<PostDetailViewmodel>()
        .sharePost(postModell.toJson());
    if (response.statusCode == 200) {
      context.go(AppRoutes.postScreenPage);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Gönderi Paylaşıldı.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Gönderi Paylaşılamadı.')),
      );
    }
  }


}

