import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/pages/ExplorePage/explore_view.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupsPage/groups_view.dart';
import 'package:moto_kent/pages/LoginView/login_page.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_page.dart';
import 'package:moto_kent/pages/PostSharing/post_sharing_view.dart';
import 'package:moto_kent/pages/RegisterPage/register_page.dart'; // RegisterPage import edildi
import 'package:moto_kent/pages/ProfilePage/profile_page.dart';
import 'package:moto_kent/widgets/app_layout.dart';

final _routerKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/login_page",
  navigatorKey: _routerKey,
  routes: [
    GoRoute(
      path: "/login_page",
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: "/register_page", // Yeni register_page rotası eklendi
      builder: (context, state) => RegisterPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/post_screen_page",
              builder: (context, state) => ExploreView(),
              routes: [
                GoRoute(
                  path: "post_sharing_view",
                  builder: (context, state) => const PostSharingView(),
                )
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/profile_page",
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: "post_detail_view",
                  builder: (context, state) {
                    final String? gelenDeger = state.extra as String?;
                    return PostDetailPage(
                      photoUrl: gelenDeger,
                    );
                  },
                )
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/chat_groups_page",
              builder: (context, state) => const ChatGroupsView(),
              routes: [
                GoRoute(
                  path: "create_chat_group",
                  builder: (context, state) =>  CreateChatGroupView(),
                ),
                GoRoute(
                  path: "my_groups",
                  builder: (context, state) => const MyGroupsView(),
                )
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/profile_page",
            builder: (context, state) => const ProfilePage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/profile_page",
            builder: (context, state) => const ProfilePage(),
          ),
        ]),
      ],
      builder: (context, state, navigationShell) =>
          AppLayout(statefulNavigationShell: navigationShell),
    ),
  ],
);
