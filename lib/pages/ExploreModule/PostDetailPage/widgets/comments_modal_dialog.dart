import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/widgets/comments_modal_dialog_mixin.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final int postId;
  const CommentsPage({super.key, required this.postId});

  @override
  CommentsPageState createState() => CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> with CommentsPageMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final viewModel =
            Provider.of<PostDetailViewmodel>(context, listen: false);
        context.read<PostDetailViewmodel>().fetchCommentList(widget.postId);

        scrollController.addListener(() {
          if (scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent &&
              !viewModel.isLoadingComment &&
              viewModel.currentPageComment <= viewModel.totalPagesComment) {
            viewModel
                .fetchCommentList(widget.postId); // Yeni sayfa verilerini yükle
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Yorumlar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: Consumer<PostDetailViewmodel>(
                  builder: (context, viewModel, child) => ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        itemCount: viewModel.comments.length +
                            (viewModel.isLoadingComment ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < viewModel.comments.length) {
                            return ListTile(
                              leading: CircleAvatar(
                                onBackgroundImageError:
                                    (exception, stackTrace) => FileImage(File(
                                        "${viewModel.comments[index].userProfilePhotoPath}")),
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
                      controller: commentController, hintText: "Yorum yaz..."),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: addComment,
                  icon: const Icon(Icons.send),
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
