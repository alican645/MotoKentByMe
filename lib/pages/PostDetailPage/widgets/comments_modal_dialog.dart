import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/main.dart';
import 'package:moto_kent/models/post_comment_model.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_viewmodel.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final int postId;
  const CommentsPage({super.key, required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _addComment() async {
    final newComment = _commentController.text.trim();
    if (newComment.isNotEmpty) {
      String? userId =
          await SharedPreferencesHelper().getValue<String>("user_id");
      String? photopath =
          await SharedPreferencesHelper().getValue<String>("userfoto");
      String? fullname =
          await SharedPreferencesHelper().getValue<String>("userfullname");

      var object = PostCommentModel(
        userId: userId,
        content: newComment,
        postId: widget.postId,
        userFullName: fullname,
        userProfilePhotoPath: photopath
      );
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<PostDetailViewmodel>().fetchCommentList(widget.postId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Yorumlar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: Consumer<PostDetailViewmodel>(
                  builder: (context, viewModel, child) => ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: viewModel.comments.length +
                            (viewModel.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < viewModel.comments.length) {

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${ApiConstants.baseUrl}//${viewModel.comments[index].userProfilePhotoPath}"),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(viewModel.comments[index].userFullName
                                      .toString()),
                                  Text(viewModel.comments[index].content
                                      .toString()),
                                ],
                              ),
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
                      )),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      controller: _commentController,
                      hintText: "Yorum yaz..."),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
