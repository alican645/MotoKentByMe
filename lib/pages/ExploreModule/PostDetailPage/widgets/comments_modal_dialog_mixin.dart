import 'package:flutter/material.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/post_comment_model.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/widgets/comments_modal_dialog.dart';
import 'package:provider/provider.dart';

mixin CommentsPageMixin on State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  TextEditingController get commentController => _commentController;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  void addComment() async {
    final newComment = _commentController.text.trim();
    if (newComment.isNotEmpty) {
      String? userId = await LocalStorageImpl().getValue<String>("user_id");
      String? photopath = await LocalStorageImpl().getValue<String>("userfoto");
      String? fullname =
          await LocalStorageImpl().getValue<String>("userfullname");

      var object = PostCommentModel(
          userId: userId,
          content: newComment,
          postId: widget.postId,
          userFullName: fullname,
          userProfilePhotoPath: photopath);
      var response =
          await context.read<PostDetailViewmodel>().addComment(object.toJson());
      if (response.statusCode == 200) {
        setState(() {
          context.read<PostDetailViewmodel>().addCommentToList(object);
        });
        _commentController.clear();
      }
    }
  }
}
