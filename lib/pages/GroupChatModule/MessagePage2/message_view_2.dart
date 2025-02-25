import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage2/message_viewmodel2.dart';
import 'package:provider/provider.dart';




class ChatPage extends StatefulWidget {
  const ChatPage({super.key,this.groupId});
  final int? groupId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: "Ali Can"
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }








  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: "1",
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    context.read<SendMessageViewmodel2>().fetchMessageList(widget.groupId!);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Chat(
      messages: _messages,
      onSendPressed: _handleSendPressed,
      showUserNames: true,
      user: _user,
    ),
  );
}