import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_view_mixin.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/widgets/message_item.dart';
import 'package:provider/provider.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key, this.arg});

  final Map<String, dynamic>? arg;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> with MessageViewMixin {
  @override
  void initState() {
    // Sayfa açıldığında listeyi en sona kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollJumpTo();
      context.read<SendMessageViewmodel>().fetchMessageList(groupId!);

      joinGroup();

      messageService.onReceivePost = () {
        setState(() {
          scrollToBottom();
        });
      };
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    messageService.leaveGroup(groupId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: groupName!,
        actions: [
          IconButton(
              onPressed: () {
                context.push(
                    '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}/${AppRoutes.messagePage}/${AppRoutes.groupSettingPage}',
                    extra: widget.arg!["groupId"]);
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Consumer<SendMessageViewmodel>(
              builder: (context, value, child) {
                if (value.isLoading == false) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: value.messageList.length,
                  itemBuilder: (context, index) => MessageItem(
                    messageModel: value.messageList[index],
                    userId: userId!,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                    child: CustomTextField(
                        onTap: () {
                          setState(() {
                            scrollToBottom();
                          });
                        },
                        controller: textEditingController,
                        hintText: "Mesajınızı giriniz")),
                IconButton(
                    onPressed: () async {
                      await sendMessage();
                      setState(() {
                        scrollToBottom();
                      });
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
