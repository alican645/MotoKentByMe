import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/pages/MessagePage/message_viewmodel.dart';
import 'package:moto_kent/pages/MessagePage/widgets/message_item.dart';
import 'package:moto_kent/services/generic_signalr_service.dart';
import 'package:moto_kent/services/signalr_message_service.dart';
import 'package:provider/provider.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key, this.groupId, this.userId, this.userName,this.groupName});
  final String? groupId;
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
  late final String? groupId=widget.groupId;
  late final String? userName=widget.userName;
  late final String? userId=widget.userId;

  @override
  void initState() {
    super.initState();

    // Sayfa açıldığında listeyi en sona kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) async  {
      firstScrollToBottom();
      context.read<SendMessageViewmodel>().fetchMessageList(groupId!);

      joinGroup();

      messageService.onReceivePost = () {
        setState(() {
          firstScrollToBottom();
        });

        //   messageService2.onReceiveMessage=(arguments) async {
        //     final json = arguments[0] as Map<String, dynamic>;
        //     ChatGroupMessageModel message = ChatGroupMessageModel.fromJson(json);
        //     await context.read<SendMessageViewmodel>().addLastMessage(message);
        // };
        //});
      };
    }
    );}


  @override
  void dispose() {
    super.dispose();
    messageService.leaveGroup(groupId!);
    //messageService2.invokeNameLeaveGroup;
  }

  Future<void> joinGroup() async {
    var viewmodel = context.read<SendMessageViewmodel>();
    messageService = SignalRMessageService(vm: viewmodel);
    // messageService2 = GenericSignalRService(
    //   invokeNameJoinGroup: 'CreateGroupChatConnection',
    //   methodName: 'CreateGroupChatConnection',
    //   endpoint: ApiConstants.signalRChatGroupEndpoint,
    //   invokeNameLeaveGroup: 'BrokeGroupChatConnection'
    // );

    // messageService2.initializeSignalR().then((value) {
    //   messageService2.initializeSignalR();
    // },);


    messageService.initializeSignalR().then(
      (value) {
        messageService.joinGroup(groupId!);
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
      ..groupId = groupId
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
      appBar: AppBar(
        title: Text(groupName!),
        actions: [
          IconButton(onPressed: () {
            context.push("/chat_groups_page/my_groups/message_page/group_setting_page",extra: widget.groupId  );
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

