class AppRoutes {
  AppRoutes._();
  static const String loginPage = "/login_page";

  static const String splashScreen = "/splash_screen";
  static const String registerPage = "/register_page";
  static const String registerUserProfilePage = "/register_user_profie_page";

///////////////////////////////////////////////////////////////////////////////
  static const String mapPage = "/map_page";
  static const String buyCoinPage = "buy_coin_page";
///////////////////////////////////////////////////////////////////////////////
  static const String explorePage = "/explore_page";
  static const String postDetailView = "post_detail_view";
  static const String postSharingView = "post_sharing_view";
  static const String myFavoritePosts = "my_favorite_posts";
  static const String searchPage = "search_page";
  static const String otherUserProfile =
      "other_user_profile"; //from search_page
  static const String myNotificationsPage = "my_notifications_page";
  static const String myPrivateMessagesPage = "my_private_messages_page";
  static const String privateChatPage =
      "private_chat_page"; //from my_private_messages_page or other_user_profile
///////////////////////////////////////////////////////////////////////////////
  static const String chatGroupsPage = "/chat_groups_page";
  static const String createChatGroup = "create_chat_group";
  static const String myGroups = "my_groups";
  static const String messagePage = "message_page"; //from my_groups
  static const String groupSettingPage =
      "group_setting_page"; //from message_page
  static const String searchChatGroupPage = "search_chat_group_page";
////////////////////////////////////////////////////////////////////////////////
  static const String profilePage = "/profile_page";
  static const String followedPage = "followed_page";
  static const String myAppSettingPage = "my_app_setting_page";
  static const String accountSecurityPage =
      "account_security_page"; //from my_app_setting_page
  static const String changePasswordPage =
      "change_password_page"; //from account_security_page
  static const String changeEmailPage = "change_email_page";
  static const String editProfilePage =
      "edit_profile_page"; // from profile_page or my_app_setting_page
  static const String aboutPage = "about_page"; //from my_app_setting_page
  static const String myPostsPage = "my_posts_page";
  static const String notificationSettingsPage = "notification_settings_page";
////////////////////////////////////////////////////////////////////////////////
  static const String callForHelpPage = "/call_for_help_page";
}
