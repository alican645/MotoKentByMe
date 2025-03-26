import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/private_message_model.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_view.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_viewmodel.dart';
import 'package:moto_kent/services/signalr_message_servie_2.dart';
import 'package:provider/provider.dart';

mixin PrivateChatViewMixin on State<PrivateChatView> {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  TextEditingController textEditingController = TextEditingController();
  late SignalRMessageService2 messageService;

  Future<void> scrollToBottom() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.positions.isEmpty) return;
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> joinGroup() async {
    var viewmodel = context.read<PrivateChatViewmodel>();
    messageService = SignalRMessageService2(vm: viewmodel);

    messageService
        .initializeSignalR(ApiConstants.signalRPrivateConversationHub)
        .then(
      (value) {
        messageService.joinGroup(widget.data!["connectionId"]!);
      },
    );
  }

  Future<void> sendMessage() async {
    String? senderUserId = await LocalStorageImpl().getValue<String>("user_id");
    var messageModel = PrivateMessageModel()
      ..messageContent = textEditingController.text.toString()
      ..privateConversationId = widget.data!["privateConversationId"]
      ..connectionId = widget.data!["connectionId"]
      ..senderId = senderUserId!
      ..receiverId = widget.data!["userId"]
      ..createdDate = DateTime.now();

    if (!mounted) return;
    var response = await context
        .read<PrivateChatViewmodel>()
        .sendMessage(messageModel.toJson());
    if (response.statusCode == 200) {
      //signalrdan geleni veriyi listeye ekle
      textEditingController.clear();
      scrollToBottom();
    }
  }
}
