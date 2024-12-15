import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/pages/CallForHelpPage/%20call_for_help_view.dart';
import 'package:moto_kent/pages/ExplorePage/explore_view.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupsPage/groups_view.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_view.dart';
import 'package:moto_kent/pages/LoginView/login_page.dart';
import 'package:moto_kent/pages/MessagePage/message_view.dart';
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
    // GoRoute(
    //   path: "/message_page",
    //   builder: (context, state) {
    //     final Map<String, dynamic> args =
    //     state.extra as Map<String, dynamic>;
    //     return MessageView(
    //       userName: args['userName'],
    //       groupId: args['groupId'],
    //       userId: args['userId'],
    //     );
    //   },
    // ),
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
            path: "/map_page",
            builder: (context, state) => const LocationIconMapView(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/call_for_help_page",
            builder: (context, state) => const CallForHelpView(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/chat_groups_page",
              builder: (context, state) => const ChatGroupsView(),
              routes: [
                GoRoute(
                  path: "create_chat_group",
                  builder: (context, state) => CreateChatGroupView(),
                ),
                GoRoute(
                    path: "my_groups",
                    builder: (context, state) => const MyGroupsView(),
                    routes: [
                      GoRoute(
                        path: "message_page",
                        builder: (context, state) {
                          final Map<String, dynamic> args =
                              state.extra as Map<String, dynamic>;
                          return MessageView(
                            userName: args['userName'],
                            groupId: args['groupId'],
                            userId: args['userId'],
                          );
                        },
                      ),
                    ]
                )
              ]),
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
