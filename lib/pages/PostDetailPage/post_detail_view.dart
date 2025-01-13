import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/PostDetailPage/widgets/post_detail_content_widget.dart';
import 'package:moto_kent/pages/PostDetailPage/widgets/post_detail_profile_widget.dart';
import 'package:moto_kent/pages/PostDetailPage/widgets/post_detail_route_button.dart';
import 'package:moto_kent/pages/PostDetailPage/widgets/show_rating_widget.dart';
import 'package:provider/provider.dart';

class PostDetailView extends StatefulWidget {
  final PostModel? postModel;
  const PostDetailView({super.key, this.postModel});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {


  @override
  void initState(){
    super.initState();
    fetchPostData();
  }

  Future<void> fetchPostData() async {
    await context.read<PostDetailViewmodel>().getPostByPostId(widget.postModel!.id!);
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<PostDetailViewmodel>(
      builder: (context, value, child) {
        if(value.postModel==null){
          return const CustomLoadingWidget();
        }
        return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      PostDetatilProfileWidget(
                        photoPath:
                        '${ApiConstants.baseUrl}/${value.postModel!.userPhotoPath}',
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value.postModel!.userFullName!,
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                const ShowRatingWidget(
                                  rating: 3,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PostDetailRouteButton(),
                              ],
                            )
                          ],
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
      }
    );
  }
}







