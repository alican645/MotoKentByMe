import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:provider/provider.dart';

class PostItem extends StatelessWidget {
  final PostModel postModel;

  const PostItem({
    super.key,
    required this.postModel,
  });

  @override
  Widget build(BuildContext context) {
    String postContentTitle = postModel.postContentTitle!;
    DateTime postDate = postModel.postDate!;
    String postLocation = postModel.postLocation!;
    String postContent = postModel.postContent!;

    Color postBackgroundColor = const Color(0xffd9d9d9);
    Color postBackgroundColor2 = const Color(0xffffc790);

    return GestureDetector(
      onTap: () {
        context.read<PostDetailViewmodel>().resetPagination();
        context.push("/post_detail_view", extra: postModel);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(

          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: postBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              postModel.isOriginalPost==false?Container(
                height: 30,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                  color: postBackgroundColor2,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${postModel.sharedUserFullName} tarafından paylaşıldı"),
                      const Icon(Icons.send)
                    ],
                  ),
                ),
              ):SizedBox(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(border: Border.all()),
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ClipRRect(
                                child: Image.network(
                                  '${ApiConstants.baseUrl}/${postModel.userProfilePhotoPath}',
                                  fit: BoxFit.fitWidth,
                                )),
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postContentTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.themeData.textTheme.headlineMedium!
                                  .copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              postContent,
                              style: Theme.of(context).textTheme.headlineSmall,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Image.network(
                            '${ApiConstants.baseUrl}${postModel.postCategoryPhotoPath}',
                            height: 50,
                          ),
                          const SizedBox(height: 5),
                          Text(postModel.postCategoryCategoryName!,
                              style: Theme.of(context).textTheme.titleMedium)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Utils.formatDateToDayMonthYear(postDate),
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.black54,
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(postLocation,
                              style: Theme.of(context).textTheme.labelSmall),
                        ],
                      )
                    ],
                  )
                ],),
              )

            ],
          ),
        ),
      ),
    );
  }
}
