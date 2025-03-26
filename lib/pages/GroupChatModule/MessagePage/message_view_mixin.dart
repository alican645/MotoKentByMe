import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_view.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/services/signalr_message_service.dart';
import 'package:provider/provider.dart';

mixin MessageViewMixin on State<MessageView> {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;
  late SignalRMessageService messageService;
  //late GenericSignalRService messageService2;

  late final String? groupName = widget.arg!["groupName"].toString();
  late final int? groupId = int.tryParse(widget.arg!["groupId"].toString());
  late final String? userName = widget.arg!["userName"].toString();
  late final String? userId = widget.arg!["userId"].toString();

  Future<void> joinGroup() async {
    var viewmodel = context.read<SendMessageViewmodel>();
    messageService = SignalRMessageService(vm: viewmodel);

    messageService
        .initializeSignalR(ApiConstants.signalRChatGroupEndpoint)
        .then(
      (value) {
        messageService.joinGroup(groupId!);
      },
    );
  }

  /// Listeyi en sona kaydırma işlemi
  Future<void> scrollToBottom() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  /// Listeyi en sona kaydırma işlemi
  Future<void> scrollJumpTo() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.positions.isNotEmpty) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      } else {
        return;
      }
    });
  }

  Future<void> sendMessage() async {
    var messageModel = ChatGroupMessageModel()
      ..chatGroupId = groupId
      ..content = textEditingController.text
      ..senderUserId = userId
      ..senderUserName = userName
      ..sentAt = DateTime.now();

    var response = await context
        .read<SendMessageViewmodel>()
        .sendMessage(messageModel.toJson());
    if (response.statusCode == 200) {
      //signalrdan geleni veriyi listeye ekle

      textEditingController.clear();
      scrollToBottom();
    }
  }
}
