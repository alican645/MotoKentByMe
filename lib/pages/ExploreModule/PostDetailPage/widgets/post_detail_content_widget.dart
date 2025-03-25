import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/constants/enums.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/complaint_model.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/ExploreModule/MyFavoritePostsPage/my_favorite_posts_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/widgets/comments_modal_dialog.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/widgets/ilan_photo_tab_view_2.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/widgets/post_content_button.dart';
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
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(postModel.postContentTitle!)),
                  SizedBox(
                    height: 75,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SvgPicture.asset(
                          Utils.getEnumValue(PostCategoryEnum
                              .values[postModel.postCategoryEnum!]),
                          height: 50,
                        )),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PostContentButton(
                  color: Colors.orange,
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
                  color: Colors.orange,
                  onPressed: () async {
                    await _showComplaintDialog(context);
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(postModel.postContent!),
                      const SizedBox(
                        height: 20,
                      ),
                      postModel.postCategoryEnum == 2
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: postModel.surveyItems!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Text(postModel
                                          .surveyItems![index].content!),
                                      Text(
                                        " (${postModel.surveyItems![index].voteCount})",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  leading: Radio<int>(
                                    value: postModel.surveyItems![index].id!,
                                    groupValue: postModel.votedSurveyItemId,
                                    onChanged: (value) async {
                                      await context
                                          .read<PostDetailViewmodel>()
                                          .votePost(
                                            DataObjects.votePost(
                                              postModel.id!,
                                              postModel.userId!,
                                              postModel.surveyItems![index].id!,
                                            ),
                                          );
                                    },
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
                      postModel.postCategoryEnum == PostCategoryEnum.ilan.index
                          ? IlanPhotoTabView2(
                              selectedImages:
                                  postModel.postIlanPhotos as List<String>,
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  Utils.formatDateToDayMonthYear(postModel.createdDate!),
                  style: const TextStyle(fontSize: 10),
                ),
                PostContentButton(
                    color: Colors.green,
                    onPressed: () async {
                      await likePost(context, true);
                    },
                    content: "Like",
                    count: postModel.likes,
                    iconData: Icons.thumb_up_alt),
                PostContentButton(
                    color: Colors.red,
                    onPressed: () async {
                      await likePost(context, false);
                    },
                    count: postModel.dislikes,
                    content: "Dislike",
                    iconData: Icons.thumb_down_alt),
                PostContentButton(
                    color: Colors.blue,
                    onPressed: () async {
                      showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return CommentsPage(
                            postId: postModel.id!,
                          );
                        },
                      );
                    },
                    count: postModel.commentCount,
                    content: "Comment",
                    iconData: Icons.comment),
                Text(
                  TurkeyProvince.getCityNameByPlateCode(postModel.illerEnum!),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showComplaintDialog(BuildContext context) async {
    var reasons = Provider.of<PostDetailViewmodel>(context, listen: false).list;
    var selectedID = await ComplaintDialog.show(
        context: context,
        reasons: reasons,
        title: "Kullanıcıyı Şikayet Nedenini Seçiniz");
    String reportedUser = postModel.userId!;
    String? complainingUser =
        await LocalStorageImpl().getValue<String>("user_id");

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
      log("post_detail_content_add_complaint", error: ex.toString());
    }
  }

  void resetMyFavoritePage(BuildContext context) {
    context.read<MyFavoritePostsViewmodel>().resetPagination();
  }

  Future<void> favoritePost(BuildContext context) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var data = DataObjects.favoritePost(postModel.id!, userId!);
    await context.read<PostDetailViewmodel>().favoritePost(data);
  }

  Future<void> likePost(BuildContext context, isLike) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    await context
        .read<PostDetailViewmodel>()
        .likePost(DataObjects.likePost(postModel.id!, userId!, isLike));
  }
}
