import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/fallow_button.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/AppBarModule/OtherProfilePage/other_profile_view.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_view_mixin.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/widgets/post_detail_content_widget.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/widgets/post_detail_profile_widget.dart';
import 'package:provider/provider.dart';

class PostDetailView extends StatefulWidget {
  final PostModel? postModel;

  const PostDetailView({super.key, this.postModel});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView>
    with PostDetailViewMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        followerRelationshipEndPoint(context);
        fetchPostData();
        fetchComplaintReasons();
        userId = await LocalStorageImpl().getValue<String>("user_id");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Ekranın daralmasını önler
      appBar: CustomAppBar(),
      body: Consumer<PostDetailViewmodel>(builder: (context, value, child) {
        if (value.postModel == null) {
          return const CustomLoadingWidget();
        }
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            PostDetatilProfileWidget(
                              postUserId: widget.postModel!.userId!,
                              photoPath:
                                  '${ApiConstants.baseUrl}/${value.postModel!.userProfilePhotoPath}',
                            ),
                            StaticRatingWidget(
                                rating: value.postModel!.totalRating!)
                          ],
                        ),
                        Flexible(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  value.postModel!.userFullName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                userId == widget.postModel!.userId
                                    ? const SizedBox()
                                    : PostDetailPageButton(
                                        content: "Mesaj At",
                                        onPressed: () async {
                                          await startConversation(context);
                                        },
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                userId == widget.postModel!.userId
                                    ? const SizedBox()
                                    : value.isFollow
                                        ? PostDetailPageButton(
                                            onPressed: () async {
                                              await followOrUnfollowUser(
                                                  context, false);
                                            },
                                            content: "Takipten Çık",
                                          )
                                        : PostDetailPageButton(
                                            onPressed: () async {
                                              //await followUser(context);
                                              await followOrUnfollowUser(
                                                  context, true);
                                            },
                                            content: "Takip Et",
                                          ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              PostDetailContentWidget(
                postModel: value.postModel!,
              )
            ],
          ),
        );
      }),
    );
  }
}
