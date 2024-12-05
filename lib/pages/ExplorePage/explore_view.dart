import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/services/signalr_service.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final Color _categorySelectionBarColor = const Color(0xfff48a34);
  final ScrollController _scrollController = ScrollController();
  late SignalRService _signalRService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ExploreViewmodel>(context, listen: false);
      viewModel.fetchPostList();
      viewModel.fetchPostCategoryList();

      // SignalR servisini başlat
      _signalRService = SignalRService(context);
      _signalRService.initializeSignalR();

      // SignalR'dan gelen verileri dinle
      _signalRService.onReceivePost = () {
        setState(() {

            print("veri geldi");
        });
      };

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !viewModel.isLoading &&
            viewModel.currentPage <= viewModel.totalPages) {
          viewModel.fetchAllOrCategoryId(); // Yeni sayfa verilerini yükle
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: width,
          child: Image.asset(
            "assets/images/motorlar2.png",
            fit: BoxFit.fill,
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
                right: width * 0.05, left: width * 0.05, top: width * 0.05),
            child: Column(
              children: [
                _categorySelectionBar(),
                SizedBox(
                  height: width * 0.01,
                ),
                Flexible(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final viewModel = context.read<ExploreViewmodel>();

                      viewModel.resetPagination(); // Pagination sıfırlanır
                      await viewModel.fetchPostList(); // Tüm postlar yeniden yüklenir
                    },
                    child: Consumer<ExploreViewmodel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.posts.isEmpty && viewModel.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemCount: viewModel.posts.length +
                              (viewModel.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < viewModel.posts.length) {
                              final post = viewModel.posts[index];
                              return GestureDetector(
                                onTap: () {
                                  context.go(
                                    '/post_screen_page/postContentScreenPage',
                                    extra: post,
                                  );
                                },
                                child: PostItem(
                                  postModel: post,
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Container _categorySelectionBar() {
    return Container(
      decoration: BoxDecoration(
          color: _categorySelectionBarColor,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                context.go("/post_screen_page/post_sharing_view");
              },
              child: const Icon(
                Icons.add_circle,
                size: 36,
                color: Colors.white,
              ),
            ),
            Consumer<ExploreViewmodel>(builder: (context, value, child) =>
               Visibility(
                  visible: value.showNewPostBtn,
                  child: GestureDetector(
                    onTap: () async {
                      value.changeShowNewPostBtn();
                      await value.fetchPostList();
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                        child: Text("Yeni Göderileri Gör"),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
            ),
            Consumer<ExploreViewmodel>(
              builder: (context, value, child) =>
                  Button(list: value.postCategoryModelList),
            )
          ],
        ),
      ),
    );
  }
}

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

    return Padding(
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
                    height: 100,
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ClipRRect(
                          child: Image.network(
                        '${ApiConstants.baseUrl}${postModel.userPhotoPath}',
                        fit: BoxFit.fill,
                      )),
                    )),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postContentTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                Text(Utils.formatDateToDayMonthYear(postDate), style: Theme.of(context).textTheme.titleSmall),
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
    );
  }
}

class Button extends StatelessWidget {
  final List<dynamic> list;
  const Button({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Row(
        children: [
          Text(
            "Kategori Seç",
            style: TextStyle(color: Colors.white),
          ),
          Icon(
            Icons.arrow_drop_down_circle,
            size: 36,
            color: Colors.white,
          )
        ],
      ),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => ListItems(
            list: list,
          ),
          direction: PopoverDirection.bottom,
          backgroundColor: Colors.white,
          width: 200,
          height: 400,
          arrowHeight: 15,
          arrowWidth: 30,
          arrowDxOffset: 1000,
        );
      },
    );
  }
}

class ListItems extends StatelessWidget {
  final List<dynamic> list;
  const ListItems({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              itemBuilder: (context, index) => ChoiceCategoryItem(
                categoryId:list[index].id ,
                  iconPath: '${ApiConstants.baseUrl}${list[index].photoPath}',
                  color: Colors.amber[300]!,
                  categoryName: list[index].categoryName!),
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceCategoryItem extends StatelessWidget {
  final int categoryId;
  final String iconPath;
  final Color color;
  final String categoryName;
  const ChoiceCategoryItem(
      {super.key,
        required this.categoryId,
      required this.iconPath,
      required this.color,
      required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            context.read<ExploreViewmodel>().changeCategory(categoryId); // Kategori değişimi
            await context.read<ExploreViewmodel>().fetchAllOrCategoryId();
            },
          child: Container(
            height: 50,
            color: color,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(categoryName),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(iconPath),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
