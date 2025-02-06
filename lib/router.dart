import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/pages/BuyCoinPage/buy_coin_view.dart';
import 'package:moto_kent/pages/CallForHelpPage/%20call_for_help_view.dart';
import 'package:moto_kent/pages/ExplorePage/explore_view.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/group_setting_view.dart';
import 'package:moto_kent/pages/GroupsPage/JoinGroupRequestPage/join_group_request_view.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupsPage/SearchChatGroupPage/search_chat_group_view.dart';
import 'package:moto_kent/pages/GroupsPage/groups_view.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_view.dart';
import 'package:moto_kent/pages/LoginView/login_page.dart';
import 'package:moto_kent/pages/MessagePage/message_view.dart';
import 'package:moto_kent/pages/MyFavoritePostsPage/my_favorite_posts_view.dart';
import 'package:moto_kent/pages/MyNotificationsPage/my_notifications_view.dart';
import 'package:moto_kent/pages/MyPrivateMessagesPage/my_private_messages_view.dart';
import 'package:moto_kent/pages/OtherProfilePage/other_profile_view.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_view.dart';
import 'package:moto_kent/pages/PostSharing/post_sharing_view.dart';
import 'package:moto_kent/pages/PrivateChatPage/private_chat_view.dart';
import 'package:moto_kent/pages/RegisterPage/register_page.dart'; // RegisterPage import edildi
import 'package:moto_kent/pages/ProfilePage/profile_page.dart';
import 'package:moto_kent/pages/SearchPage/search_view.dart';
import 'package:moto_kent/widgets/app_layout.dart';

final _routerKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.loginPage,
  navigatorKey: _routerKey,
  routes: [
    GoRoute(
      path: AppRoutes.loginPage,
      name: "login_page",
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.joinGroupRequestPage,
      name: "join_group_request_page",
      builder: (context, state) {
        int data = state.extra as int;
        return JoinGroupRequestView(
          groupId: data,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.myFavoritePosts,
      name: "my_favorite_posts",
      builder: (context, state) => const MyFavoritePostsView(),
    ),
    GoRoute(
      path: AppRoutes.myNotificationsPage,
      name: "my_notifications_page",
      builder: (context, state) => const MyNotificationsView(),
    ),
    GoRoute(
      path: AppRoutes.buyCoinPage,
      name: "buy_coin_page",
      builder: (context, state) => const BuyCoinView(),
    ),
    GoRoute(
      path: AppRoutes.searchChatGroupPage,
      name: "search_chat_group_page",
      builder: (context, state) => const SearchChatGroupView(),
    ),
    GoRoute(
      path: AppRoutes.postDetailView,
      builder: (context, state) {
        final postModel = state.extra as PostModel;
        return PostDetailView(postModel: postModel);
      },
    ),
    GoRoute(
      path: AppRoutes.myPrivatePessagesPage,
      builder: (context, state) {
        return MyPrivateMessagesView();
      },
    ),
    GoRoute(
      path: AppRoutes.searchPage,
      builder: (context, state) => SearchView(),
    ),
    GoRoute(
      path: AppRoutes.otherUserProfile,
      builder: (context, state) {
        final data = state.extra as String;
        return OtherProfileView(
          userID: data,
        );
      },
    ),
    //my_private_messages_page
    GoRoute(
      path: AppRoutes.privateChatPage,
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return PrivateChatView(
          userId: args["userId"],
          connectionId: args["connectionId"],
          privateConversationId: args["privateConversationId"],
        );
      },
    ),
    GoRoute(
        path: AppRoutes.messagePage,
        builder: (context, state) {
          final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return MessageView(
            userName: args['userName'],
            groupId: args['groupId'],
            userId: args['userId'],
            groupName: args['groupName'],
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.groupSettingPage,
            builder: (context, state) {
              int groupId = state.extra as int;
              return GroupSettingView(
                groupId: groupId,
              );
            },
          )
        ]),
    GoRoute(
      path: AppRoutes.registerPage, // Yeni register_page rotası eklendi
      builder: (context, state) => RegisterPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.postScreenPage,
              builder: (context, state) => ExploreView(),
              routes: [
                GoRoute(
                  path: AppRoutes.postSharingView,
                  builder: (context, state) => const PostSharingView(),
                ),
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.mapPage,
            builder: (context, state) =>  LocationIconMapView(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.callForHelpPage,
            builder: (context, state) => const CallForHelpView(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.chatGroupsPage,
              builder: (context, state) => const ChatGroupsView(),
              routes: [
                GoRoute(
                  path: AppRoutes.createChatGroup,
                  builder: (context, state) => CreateChatGroupView(),
                ),
                GoRoute(
                    path: AppRoutes.myGroups,
                    name: "my_groups",
                    builder: (context, state) => const MyGroupsView(),
                    routes: [])
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.profilePage,
            builder: (context, state) => const ProfilePage(),
          ),
        ]),
      ],
      builder: (context, state, navigationShell) =>
          AppLayout(statefulNavigationShell: navigationShell),
    ),
  ],
);
