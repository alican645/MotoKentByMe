import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/private_message_model.dart';
import 'package:moto_kent/pages/PrivateChatPage/private_chat_viewmodel.dart';
import 'package:moto_kent/services/signalr_message_servie_2.dart';
import 'package:moto_kent/utils/utils.dart';
import 'package:provider/provider.dart';

class PrivateChatView extends StatefulWidget {
  final String? userId;
  final String? connectionId;
  final int? privateConversationId;
  const PrivateChatView({super.key, this.userId, this.connectionId,this.privateConversationId});

  @override
  State<PrivateChatView> createState() => _PrivateChatViewState();
}

class _PrivateChatViewState extends State<PrivateChatView> {
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  late SignalRMessageService2 messageService;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında listeyi en sona kaydır
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        context.read<PrivateChatViewmodel>().initialize(widget.userId!);
        joinGroup();

        messageService.onReceivePost = () {
          setState(() {});
        };
      },
    );
  }

  Future<void> joinGroup() async {
    var viewmodel = context.read<PrivateChatViewmodel>();
    messageService = SignalRMessageService2(vm: viewmodel);

    messageService
        .initializeSignalR(ApiConstants.signalRPrivateConversationHub)
        .then(
      (value) {
        messageService.joinGroup(widget.connectionId!);
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
    messageService.leaveGroup(widget.connectionId!);

  }

  Future<void> sendMessage() async {
    String? senderUserId=await SharedPreferencesHelper().getValue<String>("user_id");
    var messageModel = PrivateMessageModel()
      ..messageContent=textEditingController.text.toString()
      ..privateConversationId=widget.privateConversationId
      ..connectionId=widget.connectionId
      ..senderId=senderUserId!
      ..receiverId=widget.userId
      ..createdDate=DateTime.now();

    if(!mounted) return;
    var response = await context
        .read<PrivateChatViewmodel>()
        .sendMessage(messageModel.toJson());
    if (response.statusCode == 200) {
      //signalrdan geleni veriyi listeye ekle
      textEditingController.clear();

    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {

      },
      child: Consumer<PrivateChatViewmodel>(
          builder: (context, value, child) {
          return Scaffold(
            appBar: CustomAppBar(
              title:  value.userModel!=null?value.userModel!.fullName!:"",
              actions: [
                IconButton(onPressed: () {

                }, icon: const Icon(Icons.settings))
              ],
            ),
            body:
              value.isLoading == false ? const CustomLoadingWidget():
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Flexible(
                    child:  ListView.builder(
                        controller: scrollController,
                        itemCount: value.messageList.length,
                        itemBuilder: (context, index) {
                          return PrivateMessageItem(receiverUserId: widget.userId!,privateMessageModel: value.messageList[index],);
                        },
                      ),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                            child: CustomTextField(
                                controller: textEditingController,
                                hintText: "Mesajınızı giriniz")),
                        IconButton(
                            onPressed: () async {
                              sendMessage();
                            }, icon: const Icon(Icons.send)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PrivateMessageItem extends StatelessWidget {
  final PrivateMessageModel privateMessageModel;
  final String receiverUserId;
  const PrivateMessageItem({
    super.key,
    required this.privateMessageModel,
    required this.receiverUserId
  });


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: receiverUserId==privateMessageModel.senderId?Alignment.centerLeft:Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width / 1.5,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(privateMessageModel.senderId!),
            Text(privateMessageModel.messageContent!),
            Align(
              alignment: Alignment.centerRight,
              child: Text(Utils.getCurrentTime(privateMessageModel.createdDate!)),
            )
          ],
        ),
      ),
    );
  }
}
