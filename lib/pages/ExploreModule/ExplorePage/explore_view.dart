import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/widgets/banner_widget.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/widgets/category_selection_bar.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/widgets/post_item.dart';
import 'package:moto_kent/services/signalr_service.dart';
import 'package:provider/provider.dart';

import 'package:badges/badges.dart' as badges;


class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final ScrollController _scrollController = ScrollController();
  late SignalRService _signalRService;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = Provider.of<ExploreViewmodel>(context, listen: false);
      await viewModel.fetchPostList();
      // SignalR servisini başlat
      _signalRService = SignalRService(context);
      _signalRService.initializeSignalR();

      // SignalR'dan gelen verileri dinle
      _signalRService.onReceivePost = () {};

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !viewModel.isLoading &&
            viewModel.currentPage <= viewModel.totalPages) {
          viewModel.fetchAllOrCategoryId(); // Yeni sayfa verilerini yükle
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar22(
        actions: [
              IconButton(
                onPressed: () {
                  context.push('/search_page');
                },
                icon: const Icon(Icons.search),
                tooltip: 'Search',
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.myNotificationsPage);
                  context.read<ExploreViewmodel>().resetNotification();
                },
                child: badges.Badge(
                  showBadge:  Provider.of<ExploreViewmodel>(context).notificationCount ==
                            0
                        ? false
                        : true,
                  badgeContent: Text(
                      Provider.of<ExploreViewmodel>(context).notificationCount ==
                              0
                          ? ""
                          : Provider.of<ExploreViewmodel>(context)
                              .notificationCount
                              .toString()),
                  child: const Icon(Icons.notifications),
                ),
              ),
              const SizedBox(width: 5,),
              IconButton(
                onPressed: () {
                  context.push('/my_favorite_posts');
                },
                icon: const Icon(Icons.star),
                tooltip: 'Favorites',
              ),
              IconButton(
                onPressed: () {
                  context.push('/my_private_messages_page');
                },
                icon: const Icon(Icons.message),
                tooltip: 'Messages',
              ),
            ],
      ),
      body: Column(
        children: [
          AdSlider(
            width: width,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                  right: width * 0.05, left: width * 0.05, top: width * 0.01),
              child: Column(
                children: [
                  const CategorySelectionBar(),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  Flexible(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final viewModel = context.read<ExploreViewmodel>();
      
                        viewModel.resetPagination(); // Pagination sıfırlanır
      
                        await viewModel
                            .fetchAllOrCategoryId();// Tüm postlar yeniden yüklenir
                        setState(() {
      
                        });
                      },
                      child: Consumer<ExploreViewmodel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.posts.isEmpty && viewModel.isLoading) {
                            return const Center(
                                child: CustomLoadingWidget());
                          }
      
                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: viewModel.posts.length +
                                (viewModel.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < viewModel.posts.length) {
                                final post = viewModel.posts[index];
                                return PostItem(
                                  postModel: post,
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
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}


