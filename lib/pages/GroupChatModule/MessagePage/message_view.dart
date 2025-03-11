import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/message_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/MessagePage/widgets/message_item.dart';
import 'package:moto_kent/services/signalr_message_service.dart';
import 'package:provider/provider.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key, this.groupId, this.userId, this.userName,this.groupName});
  final int? groupId;
  final String? userId;
  final String? userName;
  final String? groupName;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late SignalRMessageService messageService;
  //late GenericSignalRService messageService2;

  late final String? groupName=widget.groupName;
  late final int?   groupId=widget.groupId;
  late final String? userName=widget.userName;
  late final String? userId=widget.userId;

  @override
  void initState() {


    // Sayfa açıldığında listeyi en sona kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) async  {
     _scrollJumpTo();
      context.read<SendMessageViewmodel>().fetchMessageList(groupId!);

      joinGroup();

      messageService.onReceivePost = () {
        setState(() {
         _scrollToBottom();
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

  Future<void> joinGroup() async {
    var viewmodel = context.read<SendMessageViewmodel>();
    messageService = SignalRMessageService(vm: viewmodel);


    messageService.initializeSignalR(ApiConstants.signalRChatGroupEndpoint).then(
      (value) {
        messageService.joinGroup(groupId!);
      },
    );
  }

  /// Listeyi en sona kaydırma işlemi
  Future<void> _scrollToBottom() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

  }  /// Listeyi en sona kaydırma işlemi
  Future<void> _scrollJumpTo() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });

  }



  Future<void> sendMessage() async {
    var messageModel = ChatGroupMessageModel()
      ..chatGroupId = groupId
      ..content = _textEditingController.text
      ..senderUserId = userId
      ..senderUserName = userName
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
      appBar: CustomAppBar(
        title: groupName!,
        actions: [
          IconButton(onPressed: () {
            context.push("${AppRoutes.messagePage}/${AppRoutes.groupSettingPage}",extra: widget.groupId  );
          }, icon: const Icon(Icons.settings))
        ],
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
                  userId: userId!,
                  userName: userName!,
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
                      onTap: () {
                        setState(() {
                          _scrollToBottom();
                        });
                      },
                        controller: _textEditingController,
                        hintText: "Mesajınızı giriniz")),
                IconButton(
                    onPressed: () async {
                      await sendMessage();
                      setState(() {
                        _scrollToBottom();
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

