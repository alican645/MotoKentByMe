import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_view.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_viewmodel.dart';
import 'package:provider/provider.dart';

mixin PostDetailViewMixin on State<PostDetailView> {
  String? userId;
  Future<void> fetchPostData() async {
    await context
        .read<PostDetailViewmodel>()
        .getPostByPostId(widget.postModel!.id!);
  }

  Future<void> fetchComplaintReasons() async {
    await context.read<PostDetailViewmodel>().fetchComplaintReason();
  }

  Future<void> followOrUnfollowUser(BuildContext context, isFollow) async {
    var respnse = await context
        .read<PostDetailViewmodel>()
        .followOrUnfollowUser(
            {"followerId": userId, "followedUserId": widget.postModel!.userId},
            isFollow);

    if (respnse.statusCode == 200) {
      await followerRelationshipEndPoint(context);
      await fetchPostData();
    }
  }

  Future<void> followerRelationshipEndPoint(BuildContext context) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    await context.read<PostDetailViewmodel>().followerRelationshipEndPoint(
        {"followerId": userId, "followedUserId": widget.postModel!.userId});
  }

  Future<void> startConversation(BuildContext context) async {
    var response = await context
        .read<PostDetailViewmodel>()
        .startPrivateConversation(widget.postModel!.userId!);
    if (response.statusCode == 200) {
      final Map<String, dynamic> args = {
        "userId": widget.postModel!.userId.toString(),
        "connectionId": response.data["connectionId"],
        "privateConversationId": response.data["privateConversationId"]
      };
      context.push(
          '${AppRoutes.explorePage}/${AppRoutes.postDetailView}/${AppRoutes.privateChatPage}',
          extra: args);
    }
  }
}
