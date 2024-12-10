import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/pages/MessagePage/message_viewmodel.dart';
import 'package:moto_kent/services/signalr_message_service.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:provider/provider.dart';

class MessageView extends StatefulWidget {
  MessageView({super.key, this.groupId, this.userId, this.userName});
  String? groupId;
  String? userId;
  String? userName;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late SignalRMessageService messageService;

  @override
  void initState() {
    super.initState();

    // Sayfa açıldığında listeyi en sona kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firstScrollToBottom();
      context.read<SendMessageViewmodel>().fetchMessageList(widget.groupId!);

      joinGroup();

      messageService.onReceivePost = () {
        setState(() {
          firstScrollToBottom();
        });
      };
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageService.leaveGroup(widget.groupId!);
  }

  Future<void> joinGroup() async {
    var viewmodel = context.read<SendMessageViewmodel>();
    messageService = SignalRMessageService(vm: viewmodel);

    messageService.initializeSignalR().then(
      (value) {
        messageService.joinGroup(widget.groupId!);
      },
    );
  }

  /// Listeyi en sona kaydırma işlemi
  Future<void> _scrollToBottom() async {
    setState(() {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> firstScrollToBottom({bool isAnimated = true}) async {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;

    if (currentScroll < maxScroll) {
      if (isAnimated) {
        // Perform the animated scroll only on the first call
        await _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      } else {
        // Perform an immediate jump to the bottom on subsequent recursive calls
        _scrollController.jumpTo(maxScroll);
      }

      // Recursive call with isAnimated set to false
      await firstScrollToBottom(isAnimated: false);
    }
  }

  Future<void> sendMessage() async {
    var messageModel = ChatGroupMessageModel()
      ..groupId = widget.groupId
      ..content = _textEditingController.text
      ..senderUserId = widget.userId
      ..senderUserName = widget.userName
      ..sentAt = DateTime.now();

    var response = await context
        .read<SendMessageViewmodel>()
        .sendMessage(messageModel.toJson());
    if (response.statusCode == 200) {
      //signalrdan geleni veriyi listeye ekle
      _textEditingController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GroupName"),
      ),
      body: Column(
        children: [
          Flexible(
            child: Consumer<SendMessageViewmodel>(
              builder: (context, value, child) => ListView.builder(
                controller: _scrollController,
      
                itemCount: value.messageList.length,
                itemBuilder: (context, index) => MessageItem(
                  messageModel: value.messageList[index],
                  userId: widget.userId!,
                  userName: widget.userName!,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                    child: CustomTextField(
                        controller: _textEditingController,
                        labelText: "Mesajınızı giriniz")),
                IconButton(
                    onPressed: () async {
                      await sendMessage().then((value) {
                        _scrollToBottom();
                      },);
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

class MessageItem extends StatelessWidget {
  const MessageItem(
      {super.key,
      required this.userId,
      required this.userName,
      required this.messageModel});
  final String userId;
  final String userName;
  final ChatGroupMessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: userId == messageModel.senderUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width / 1.5,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messageModel.senderUserName!),
            Text(messageModel.content!),
            Align(
              alignment: Alignment.centerRight,
              child: Text(Utils.getCurrentTime(messageModel.sentAt!)),
            )
          ],
        ),
      ),
    );
  }
}
