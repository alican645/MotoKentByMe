


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/utils/utils.dart';

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

    return GestureDetector(
      onTap: () {
        context.go("/post_screen_page/post_detail_view",extra: postModel);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: postBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              '${ApiConstants.baseUrl}/${postModel.userPhotoPath}',
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
                          style: AppTheme.themeData.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w500,fontSize: 16
                          ),
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
                        '${ApiConstants.baseUrl}${postModel.postCategoryIconPath}',
                        height: 50,
                      ),
                      const SizedBox(height: 5),
                      Text(postModel.postCategoryName!,
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
            ],
          ),
        ),
      ),
    );
  }
}
