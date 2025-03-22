import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/my_private_messages_view.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/my_private_messages_viewmodel.dart';
import 'package:provider/provider.dart';

mixin MyPrivateMessageViewMixin on State<MyPrivateMessagesView> {
  final _appBarTitle = "Sohbetlerim";
  String get appBarTitle => _appBarTitle;

  Future<void> startConversation(String userId) async {
    var response = await context
        .read<MyPrivateMessagesViewmodel>()
        .startPrivateConversation(userId);
    if (response.statusCode == 200) {
      final Map<String, dynamic> args = {
        "userId": userId,
        "connectionId": response.data["connectionId"],
        "privateConversationId": response.data["privateConversationId"]
      };
      if (!mounted) return;
      context.push(
          '${AppRoutes.explorePage}/${AppRoutes.myPrivateMessagesPage}/${AppRoutes.privateChatPage}',
          extra: args);
    }
  }
}
