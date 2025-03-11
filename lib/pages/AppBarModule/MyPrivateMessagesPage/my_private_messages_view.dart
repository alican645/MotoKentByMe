import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/pages/AppBarModule/MyNotificationsPage/my_notifications_view.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/my_private_messages_mixin.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/my_private_messages_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/MyPrivateMessagesPage/widgets/private_conversation_item.dart';
import 'package:provider/provider.dart';

class MyPrivateMessagesView extends StatefulWidget {
  const MyPrivateMessagesView({super.key});

  @override
  State<MyPrivateMessagesView> createState() => _MyPrivateMessagesViewState();
}

class _MyPrivateMessagesViewState extends State<MyPrivateMessagesView>
    with MyPrivateMessageViewMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context
            .read<MyPrivateMessagesViewmodel>()
            .fetchPrivateConversation();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: appBarTitle,
        ),
        body: Consumer<MyPrivateMessagesViewmodel>(
          builder: (context, value, child) => ListView.builder(
              itemCount: value.list.length,
              itemBuilder: (context, index) => PrivateConversationItem(
                onTap: () => startConversation(value.list[index].userId!),
                    model: value.list[index],
                  )),
        ));
  }
}
