

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/MediaQueryHelper.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/PostDetailPage/widgets/post_content_button.dart';
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
                    height: MediaQueryHelper.height(75),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                            '${ApiConstants.baseUrl}${postModel.postCategoryIconPath}')),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PostContentButton(
                  onPressed: () {
                    //context.read<PostDetailViewmodel>().;
                  },
                  iconData: Icons.star,
                  content: 'Favorile',
                ),
                PostContentButton(
                  iconData: Icons.send,
                  content: 'Paylaş',
                  onPressed: () async {
                    await quotePost(context);
                  },
                ),
                PostContentButton(
                  iconData: Icons.report_outlined,
                  content: 'Şikayet Et',
                ),
              ],
            ),
            SizedBox(
              height: MediaQueryHelper.height(15),
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
                      await likePost(context,true);
                    },
                    content: "Like",
                    count: postModel.likes,
                    iconData: Icons.thumb_up_alt),
                PostContentButton(
                    onPressed: () async {
                      await likePost(context,false);
                    },
                    count: postModel.dislikes,
                    content: "Dislike",
                    iconData: Icons.thumb_down_alt),
                Text(postModel.postLocation!)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> quotePost(BuildContext context) async {
    String? userId = await SharedPreferencesHelper()
        .getValue<String>("user_id");
    var data=DataObjects.quotePost(postModel.id!,userId! );
    var response=await context.read<PostDetailViewmodel>().quotePost(data);
    if(response.statusCode==200){
      Navigator.canPop(context);
    }
  }

  Future<void> likePost(BuildContext context,isLike) async {
    String? userId = await SharedPreferencesHelper()
        .getValue<String>("user_id");
    await context.read<PostDetailViewmodel>().likePost(
        DataObjects.likePost(postModel.id!, userId!, isLike));

  }
}