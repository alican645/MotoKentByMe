import 'package:flutter/material.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_view.dart';
import 'package:moto_kent/services/signalr_message_service.dart';

mixin MessageViewMixin on State<MessageView> {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;
  late SignalRMessageService messageService;
  //late GenericSignalRService messageService2;

  late final String? groupName = widget.groupName;
  late final int? groupId = widget.groupId;
  late final String? userName = widget.userName;
  late final String? userId = widget.userId;
}
