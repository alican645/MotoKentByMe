import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/init/Helpers/MediaQueryHelper.dart';
import 'package:moto_kent/pages/CallForHelpPage/%20call_for_help_view.dart';
import 'package:moto_kent/pages/CallForHelpPage/call_for_help_viewmodel.dart';
import 'package:moto_kent/pages/ExplorePage/explore_view.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_group_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/group_setting_view.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_view.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/groups_view.dart';
import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_view.dart';
import 'package:moto_kent/pages/LoactionIconMapPage/loaction_icon_map_viewmodel.dart';
import 'package:moto_kent/pages/LoginView/login_page.dart';
import 'package:moto_kent/pages/LoginView/login_viewmodel.dart';
import 'package:moto_kent/pages/MessagePage/message_view.dart';
import 'package:moto_kent/pages/MessagePage/message_viewmodel.dart';
import 'package:moto_kent/pages/MyFavoritePostsPage/my_favorite_posts_view.dart';
import 'package:moto_kent/pages/MyFavoritePostsPage/my_favorite_posts_viewmodel.dart';
import 'package:moto_kent/pages/OtherProfilePage/other_profile_view.dart';
import 'package:moto_kent/pages/OtherProfilePage/other_profile_viewmodel.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_view.dart';
import 'package:moto_kent/pages/PostDetailPage/post_detail_viewmodel.dart';
import 'package:moto_kent/pages/PostSharing/post_sharing_view.dart';
import 'package:moto_kent/pages/PostSharing/post_sharing_viewmodel.dart';
import 'package:moto_kent/pages/ProfilePage/profile_page.dart';
import 'package:moto_kent/pages/ProfilePage/profile_viewmodel.dart';
import 'package:moto_kent/pages/RegisterPage/register_page.dart';
import 'package:moto_kent/pages/RegisterPage/register_viewmodel.dart';
import 'package:moto_kent/pages/SearchPage/search_view.dart';
import 'package:moto_kent/pages/SearchPage/search_viewmodel.dart';
import 'package:moto_kent/services/firebase_notification_service.dart';
import 'package:provider/provider.dart';
import 'package:moto_kent/router.dart';

import 'init/Helpers/shared_preferences_helper.dart'; // Router dosya

Color _categorySelectionBarColor = const Color(0xfff48a34);

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Bu satır async kullanımı için gerekli
  await Firebase.initializeApp();
  await SharedPreferencesHelper().init();
  FirebaseMessaging.onBackgroundMessage(FirebaseNotificationService.firebaseMessagingBackgroundHandler);
  String initialRoute =
      await getInitialRoute(); // İlk rotayı belirlemek için token kontrolü yapılacak

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) => ExploreViewmodel(), child: const ExploreView()),
    ChangeNotifierProvider(
        create: (context) => PostSharingViewmodel(),
        child: const PostSharingView()),
    ChangeNotifierProvider(
        create: (context) => LoginViewmodel(), child: LoginPage()),
    ChangeNotifierProvider(
        create: (context) => RegisterViewmodel(), child: const RegisterPage()),
    ChangeNotifierProvider(
        create: (context) => ProfileViewmodel(), child: const ProfilePage()),
    ChangeNotifierProvider(
        create: (context) => CreateChatGroupViewmodel(),
        child: CreateChatGroupView()),
    ChangeNotifierProvider(
        create: (context) => ChatGroupsViewmodel(),
        child: const ChatGroupsView()),
    ChangeNotifierProvider(create: (context) => MyGroupsViewmodel(), child: const MyGroupsView()),
    ChangeNotifierProvider(create: (context) => PostDetailViewmodel(), child: const PostDetailView()),
    ChangeNotifierProvider(create: (context) => SearchViewmodel(), child:  const SearchView()),
    ChangeNotifierProvider(create: (context) => OtherProfileViewmodel(), child:  const OtherProfileView()),
    ChangeNotifierProvider(create: (context) => GroupSettingViewmodel(), child:  const GroupSettingView()),
    ChangeNotifierProvider(create: (context) => MyFavoritePostsViewmodel(), child:  const MyFavoritePostsView()),
    ChangeNotifierProvider(
        create: (context) => SendMessageViewmodel(), child: MessageView()),
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

  String? token =await SharedPreferencesHelper().getValue<String>('jwt_token');

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
    MediaQueryHelper.init(context,designHeight: 830,designWidth:393 );
    return MaterialApp.router(
      routerConfig: router, // Router'ı kullanarak uygulamayı başlatın
      title: 'MotoKent',
      theme: AppTheme.themeData,
    );
  }
}
