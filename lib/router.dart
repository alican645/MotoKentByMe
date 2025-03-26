import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/models/register_model.dart';
import 'package:moto_kent/pages/CallForHelpModule/CallForHelpPage/call_for_help_view.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_view.dart';
import 'package:moto_kent/pages/LoginModule/RegisterPage/register_view.dart';
import 'package:moto_kent/pages/LoginModule/RegisterUserProfile/register_user_profile_view.dart';
import 'package:moto_kent/pages/ProfileModule/AboutPage/about_view.dart';
import 'package:moto_kent/pages/ProfileModule/AccountSecurityPage/account_security_view.dart';
import 'package:moto_kent/pages/MapModule/BuyCoinPage/buy_coin_view.dart';
import 'package:moto_kent/pages/ProfileModule/ChangeEmailPage/change_email_view.dart';
import 'package:moto_kent/pages/ProfileModule/ChangePasswordPage/change_password_view.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_view.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/explore_view.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/group_setting_view.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupChatModule/SearchChatGroupPage/search_chat_group_view.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_view.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/loaction_icon_map_view.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_page.dart';
import 'package:moto_kent/pages/ProfileModule/FollowedPage/connections_view.dart';
import 'package:moto_kent/pages/ProfileModule/MyAppSettingsPage/my_app_settings_view.dart';
import 'package:moto_kent/pages/ExploreModule/MyFavoritePostsPage/my_favorite_posts_view.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_view.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/my_private_messages_view.dart';
import 'package:moto_kent/pages/AppBarModule/OtherProfilePage/other_profile_view.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_view.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_view.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_view.dart';
import 'package:moto_kent/pages/ProfileModule/MyPostPage/my_post_view.dart';
import 'package:moto_kent/pages/ProfileModule/NotificationSettingPage/notification_settings_view.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_page.dart';
import 'package:moto_kent/pages/AppBarModule/SearchPage/search_view.dart';
import 'package:moto_kent/splash_screen.dart';
import 'package:moto_kent/widgets/app_layout.dart';

final routerKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splashScreen,
  navigatorKey: routerKey,
  routes: [
    GoRoute(
      path: AppRoutes.splashScreen,
      builder: (context, state) {
        final Map<String, dynamic>? arg = state.extra as Map<String, dynamic>?;
        return SplashScreen(
          data: arg,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.loginPage,
      name: "login_page",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes
          .registerUserProfilePage, // Yeni register_page rotası eklendi
      builder: (context, state) => const RegisterUserProfileView(),
    ),
    GoRoute(
      path: AppRoutes.registerPage, // Yeni register_page rotası eklendi
      builder: (context, state) {
        final registerModel = state.extra as RegisterModel;
        return RegisterView(registerModel: registerModel);
      },
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        //Keşfet Modülü
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.explorePage,
              builder: (context, state) => const ExploreView(),
              routes: [
                GoRoute(
                    path: AppRoutes.postDetailView,
                    builder: (context, state) {
                      final postModel = state.extra as PostModel;
                      return PostDetailView(postModel: postModel);
                    },
                    routes: [
                      GoRoute(
                        path: AppRoutes.privateChatPage,
                        builder: (context, state) {
                          final Map<String, dynamic> args =
                              state.extra as Map<String, dynamic>;
                          return PrivateChatView(
                            data: args,
                          );
                        },
                      ),
                      GoRoute(
                          path: AppRoutes.otherUserProfile,
                          builder: (context, state) {
                            final data = state.extra as String;
                            return OtherProfileView(
                              userID: data,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: AppRoutes.privateChatPage,
                              builder: (context, state) {
                                final Map<String, dynamic> args =
                                    state.extra as Map<String, dynamic>;
                                return PrivateChatView(
                                  data: args,
                                );
                              },
                            ),
                          ]),
                    ]),
                GoRoute(
                  path: AppRoutes.postSharingView,
                  builder: (context, state) => const PostSharingView(),
                ),
                GoRoute(
                  path: AppRoutes.myFavoritePosts,
                  name: "my_favorite_posts",
                  builder: (context, state) => const MyFavoritePostsView(),
                ),
                GoRoute(
                    path: AppRoutes.searchPage,
                    builder: (context, state) => const SearchView(),
                    routes: [
                      GoRoute(
                          path: AppRoutes.otherUserProfile,
                          builder: (context, state) {
                            final data = state.extra as String;
                            return OtherProfileView(
                              userID: data,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: AppRoutes.privateChatPage,
                              builder: (context, state) {
                                final Map<String, dynamic> args =
                                    state.extra as Map<String, dynamic>;
                                return PrivateChatView(
                                  data: args,
                                );
                              },
                            ),
                          ]),
                    ]),
                GoRoute(
                    path: AppRoutes.myNotificationsPage,
                    name: "my_notifications_page",
                    builder: (context, state) => const MyNotificationsView(),
                    routes: [
                      GoRoute(
                          path: AppRoutes.otherUserProfile,
                          builder: (context, state) {
                            final data = state.extra as String;
                            return OtherProfileView(
                              userID: data,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: AppRoutes.privateChatPage,
                              builder: (context, state) {
                                final Map<String, dynamic> args =
                                    state.extra as Map<String, dynamic>;
                                return PrivateChatView(
                                  data: args,
                                );
                              },
                            ),
                          ]),
                      GoRoute(
                          path: AppRoutes.messagePage,
                          builder: (context, state) {
                            final Map<String, dynamic>? arg =
                                state.extra as Map<String, dynamic>?;
                            return MessageView(
                              arg: arg,
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
                                routes: [])
                          ]),
                    ]),
                GoRoute(
                    path: AppRoutes.myPrivateMessagesPage,
                    builder: (context, state) {
                      return const MyPrivateMessagesView();
                    },
                    routes: [
                      GoRoute(
                        path: AppRoutes.privateChatPage,
                        builder: (context, state) {
                          final Map<String, dynamic> args =
                              state.extra as Map<String, dynamic>;
                          return PrivateChatView(
                            data: args,
                          );
                        },
                      ),
                    ]),
              ]),
        ]),
        //Harita Modülü
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.mapPage,
              builder: (context, state) {
                final Map<String, dynamic>? arg =
                    state.extra as Map<String, dynamic>?;
                return LocationIconMapView(arg: arg);
              },
              routes: [
                GoRoute(
                  path: AppRoutes.buyCoinPage,
                  name: "buy_coin_page",
                  builder: (context, state) => const BuyCoinView(),
                ),
              ]),
        ]),
        //Yardım Çağrısı Modülü
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.callForHelpPage,
            builder: (context, state) => const CallForHelpView(),
          ),
        ]),
        //Sohbet Grupları Modülü
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
                    routes: [
                      GoRoute(
                          path: AppRoutes.messagePage,
                          builder: (context, state) {
                            final Map<String, dynamic>? arg =
                                state.extra as Map<String, dynamic>?;
                            return MessageView(
                              arg: arg,
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
                                routes: [
                                  GoRoute(
                                    path: AppRoutes.privateChatPage,
                                    builder: (context, state) {
                                      final Map<String, dynamic>? args =
                                          state.extra as Map<String, dynamic>?;
                                      return PrivateChatView(
                                        data: args,
                                      );
                                    },
                                  ),
                                  GoRoute(
                                      path: AppRoutes.otherUserProfile,
                                      builder: (context, state) {
                                        final data = state.extra as String;
                                        return OtherProfileView(
                                          userID: data,
                                        );
                                      },
                                      routes: [
                                        GoRoute(
                                          path: AppRoutes.privateChatPage,
                                          builder: (context, state) {
                                            final Map<String, dynamic>? args =
                                                state.extra
                                                    as Map<String, dynamic>?;
                                            return PrivateChatView(
                                              data: args,
                                            );
                                          },
                                        ),
                                      ]),
                                ])
                          ]),
                    ]),
                GoRoute(
                  path: AppRoutes.searchChatGroupPage,
                  name: "search_chat_group_page",
                  builder: (context, state) => const SearchChatGroupView(),
                ),
              ]),
        ]),
        //Profil Modülü
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.profilePage,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: AppRoutes.followedPage,
                  builder: (context, state) => const ConnectionsView(),
                ),
                GoRoute(
                    path: AppRoutes.myAppSettingPage,
                    builder: (context, state) => const MyAppSettingsView(),
                    routes: [
                      GoRoute(
                        path: AppRoutes.editProfilePage,
                        builder: (context, state) {
                          return const EditProfileView();
                        },
                      ),
                      GoRoute(
                        path: AppRoutes.notificationSettingsPage,
                        builder: (context, state) =>
                            const NotificationSettingsView(),
                      ),
                      GoRoute(
                          path: AppRoutes.accountSecurityPage,
                          builder: (context, state) {
                            return const AccountSecurityView();
                          },
                          routes: [
                            GoRoute(
                              path: AppRoutes.changePasswordPage,
                              builder: (context, state) =>
                                  const ChangePasswordView(),
                            ),
                            GoRoute(
                              path: AppRoutes.changeEmailPage,
                              builder: (context, state) =>
                                  const ChangeEmailView(),
                            ),
                          ]),
                      GoRoute(
                        path: AppRoutes.aboutPage,
                        name: "about_page",
                        builder: (context, state) => const AboutView(),
                      ),
                      GoRoute(
                          path: AppRoutes.myPostsPage,
                          builder: (context, state) {
                            return const MyPostView();
                          }),
                    ])
              ]),
        ]),
      ],
      builder: (context, state, navigationShell) =>
          AppLayout(statefulNavigationShell: navigationShell),
    ),
  ],
);
