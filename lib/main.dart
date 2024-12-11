import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/init/Locator/locator.dart';
import 'package:moto_kent/pages/ExplorePage/explore_view.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_chat_group_view.dart';
import 'package:moto_kent/pages/GroupsPage/CreateChatGroupPage/create_group_viewmodel.dart';
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
import 'package:moto_kent/pages/PostSharing/post_sharing_view.dart';
import 'package:moto_kent/pages/PostSharing/post_sharing_viewmodel.dart';
import 'package:moto_kent/pages/ProfilePage/profile_page.dart';
import 'package:moto_kent/pages/ProfilePage/profile_viewmodel.dart';
import 'package:moto_kent/pages/RegisterPage/register_page.dart';
import 'package:moto_kent/pages/RegisterPage/register_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_kent/router.dart'; // Router dosya
// sını import edin

Color _categorySelectionBarColor = const Color(0xfff48a34);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Bu satır async kullanımı için gerekli
  String initialRoute = await getInitialRoute(); // İlk rotayı belirlemek için token kontrolü yapılacak
  setupLocator();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExploreViewmodel(),child: const ExploreView()),
        ChangeNotifierProvider(create: (context) => PostSharingViewmodel(),child: const PostSharingView()),
        ChangeNotifierProvider(create: (context) => LoginViewmodel(),child: LoginPage()),
        ChangeNotifierProvider(create: (context) => RegisterViewmodel(),child: const RegisterPage()),
        ChangeNotifierProvider(create: (context) => ProfileViewmodel(),child: const ProfilePage()),
        ChangeNotifierProvider(create: (context) => CreateChatGroupViewmodel(),child: CreateChatGroupView()),
        ChangeNotifierProvider(create: (context) => ChatGroupsViewmodel(),child: ChatGroupsView()),
        ChangeNotifierProvider(create: (context) => MyGroupsViewmodel(),child: MyGroupsView()),
        ChangeNotifierProvider(create: (context) => SendMessageViewmodel(),child: MessageView()),
        ChangeNotifierProvider(create: (context) => LoactionIconMapViewmodel(),child: LocationIconMapView()),
      ],
      child:  MyApp(initialRoute: initialRoute)));

  // Sistem UI ayarlarını uygulayın
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Durum çubuğunu şeffaf yapar
      statusBarIconBrightness: Brightness.dark, // İkonların rengini ayarlar (örneğin: koyu)
      systemNavigationBarColor: _categorySelectionBarColor, // Alt kısımda yer alan geri ve ana ekran tuşlarının arka plan rengini ayarlar
      systemNavigationBarIconBrightness: Brightness.dark, // Alt kısımdaki ikonların rengini ayarlar (örneğin: kapalı)
    ),
  );
}

Future<String> getInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwt_token');

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
      routerConfig: router, // Router'ı kullanarak uygulamayı başlatın
      title: 'MotoKent',
      theme: AppTheme.themeData,
    );
  }
}
