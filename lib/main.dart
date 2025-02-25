import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
  import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_view.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/my_private_messages_view.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/my_private_messages_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/OtherProfilePage/other_profile_view.dart';
import 'package:moto_kent/pages/AppBarModule/OtherProfilePage/other_profile_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_view.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/SearchPage/search_view.dart';
import 'package:moto_kent/pages/AppBarModule/SearchPage/search_viewmodel.dart';
import 'package:moto_kent/pages/CallForHelpModule/CallForHelpPage/%20call_for_help_view.dart';
import 'package:moto_kent/pages/CallForHelpModule/CallForHelpPage/call_for_help_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/explore_view.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/MyFavoritePostsPage/my_favorite_posts_view.dart';
import 'package:moto_kent/pages/ExploreModule/MyFavoritePostsPage/my_favorite_posts_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_view.dart';
import 'package:moto_kent/pages/ExploreModule/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_view.dart';
import 'package:moto_kent/pages/ExploreModule/PostSharing/post_sharing_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupChatModule/CreateChatGroupPage/create_group_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/group_setting_view.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_view.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/JoinGroupRequestPage/join_group_request_view.dart';
import 'package:moto_kent/pages/GroupChatModule/JoinGroupRequestPage/join_group_request_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_view.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage2/message_view_2.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage2/message_viewmodel2.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/SearchChatGroupPage/search_chat_group_view.dart';
import 'package:moto_kent/pages/GroupChatModule/SearchChatGroupPage/search_chat_group_viewmodel.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_page.dart';
import 'package:moto_kent/pages/LoginModule/LoginView/login_viewmodel.dart';
import 'package:moto_kent/pages/LoginModule/RegisterPage/register_view.dart';
import 'package:moto_kent/pages/LoginModule/RegisterPage/register_viewmodel.dart';
import 'package:moto_kent/pages/MapModule/BuyCoinPage/buy_coin_view.dart';
import 'package:moto_kent/pages/MapModule/BuyCoinPage/buy_coin_viewmodel.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/loaction_icon_map_view.dart';
import 'package:moto_kent/pages/MapModule/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/AboutPage/about_view.dart';
import 'package:moto_kent/pages/ProfileModule/AboutPage/about_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_view.dart';
import 'package:moto_kent/pages/ProfileModule/EditProfilePage/edit_profile_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/FollowedPage/connections_view.dart';
import 'package:moto_kent/pages/ProfileModule/FollowedPage/connections_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/MyAppSettingsPage/my_app_settings_view.dart';
import 'package:moto_kent/pages/ProfileModule/MyAppSettingsPage/my_app_settings_viewmodel.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_page.dart';
import 'package:moto_kent/pages/ProfileModule/ProfilePage/profile_viewmodel.dart';
import 'package:moto_kent/router.dart';
import 'package:moto_kent/services/firebase_notification_service.dart';
import 'package:provider/provider.dart';
import 'App/app_theme.dart';

Color _categorySelectionBarColor = const Color(0xfff48a34);

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Bu satır async kullanımı için gerekli
  await Firebase.initializeApp();
  await LocalStorageImpl().init();
  FirebaseMessaging.onBackgroundMessage(FirebaseNotificationService.firebaseMessagingBackgroundHandler);
  String initialRoute =
      await getInitialRoute(); // İlk rotayı belirlemek için token kontrolü yapılacak
  runApp(MultiProvider(

      providers: [
    ChangeNotifierProvider(
        create: (context) => ExploreViewmodel(), child: const ExploreView()),
    ChangeNotifierProvider(
        create: (context) => PostSharingViewmodel(),
        child: const PostSharingView()),
    ChangeNotifierProvider(
        create: (context) => LoginViewmodel(), child: const LoginPage()),
    ChangeNotifierProvider(
        create: (context) => RegisterViewmodel(), child:  RegisterView()),
    ChangeNotifierProvider(
        create: (context) => ProfileViewmodel(), child: const ProfilePage()),
    ChangeNotifierProvider(
        create: (context) => CreateChatGroupViewmodel(),
        child: CreateChatGroupView()),
    ChangeNotifierProvider(
        create: (context) => ChatGroupsViewmodel(),
        child: const ChatGroupsView()),
    ChangeNotifierProvider(create: (context) => MyGroupsViewmodel(), child: const MyGroupsView()),
    ChangeNotifierProvider(create: (context) => BuyCoinViewmodel(), child: const BuyCoinView()),
    ChangeNotifierProvider(create: (context) => PostDetailViewmodel(), child: const PostDetailView()),
    ChangeNotifierProvider(create: (context) => SearchViewmodel(), child:  const SearchView()),
    ChangeNotifierProvider(create: (context) => OtherProfileViewmodel(), child:  const OtherProfileView()),
    ChangeNotifierProvider(create: (context) => GroupSettingViewmodel(), child:  const GroupSettingView()),
    ChangeNotifierProvider(create: (context) => MyFavoritePostsViewmodel(), child:  const MyFavoritePostsView()),
    ChangeNotifierProvider(create: (context) => SearchChatGroupViewmodel(), child:  const SearchChatGroupView()),
    ChangeNotifierProvider(create: (context) => PrivateChatViewmodel(), child:  const PrivateChatView()),
    ChangeNotifierProvider(create: (context) => MyPrivateMessagesViewmodel(), child:  const MyPrivateMessagesView()),
    ChangeNotifierProvider(create: (context) => JoinGroupRequestViewmodel(), child:  const JoinGroupRequestView()),
    ChangeNotifierProvider(create: (context) => MyNotificationsViewmodel(), child:  const MyNotificationsView()),
    ChangeNotifierProvider(create: (context) => MyAppSettingsViewmodel(), child:  const MyAppSettingsView()),
    ChangeNotifierProvider(create: (context) => EditProfileViewmodel(), child:   EditProfileView()),
    ChangeNotifierProvider(create: (context) => ConnectionsViewmodel(), child:const    ConnectionsView()),
    ChangeNotifierProvider(create: (context) => AboutViewmodel(), child:const   AboutView()),
    ChangeNotifierProvider(create: (context) => SendMessageViewmodel2(), child:const   ChatPage()),
    ChangeNotifierProvider(
        create: (context) => SendMessageViewmodel(), child: const MessageView()),
    ChangeNotifierProvider(
        create: (context) => LoactionIconMapViewmodel(),
        child: const LocationIconMapView()),
    ChangeNotifierProvider(
        create: (context) => CallForHelpViewmodel(),
        child: const CallForHelpView()),
  ], child: MyApp(initialRoute: initialRoute)));

  // Sistem UI ayarlarını uygulayın
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Durum çubuğunu şeffaf yapar
      statusBarIconBrightness:
          Brightness.dark, // İkonların rengini ayarlar (örneğin: koyu)
      systemNavigationBarColor:
          _categorySelectionBarColor, // Alt kısımda yer alan geri ve ana ekran tuşlarının arka plan rengini ayarlar
      systemNavigationBarIconBrightness: Brightness
          .dark, // Alt kısımdaki ikonların rengini ayarlar (örneğin: kapalı)
    ),
  );
}

Future<String> getInitialRoute() async {

  String? token =await LocalStorageImpl().getValue<String>('jwt_token');

  // Eğer token varsa, anasayfaya yönlendir
  if (token != null && token.isNotEmpty) {
    return "/home_page"; // Anasayfa için rotayı döndür
  } else {
    return "/login_page"; // Giriş sayfası için rotayı döndür
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [Locale('tr', 'TR')],
      locale: Locale('tr', 'TR'),
      routerConfig: router, // Router'ı kullanarak uygulamayı başlatın
      title: 'MotoKent',
      theme: AppTheme.themeData,
    );
  }
}
