import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:moto_kent/components/custom_app_bar.dart';
import 'package:moto_kent/components/custom_loading_widget.dart';
import 'package:moto_kent/components/custom_textfield.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/private_message_model.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_view_mixin.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_viewmodel.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/widgets/private_message_item.dart';
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

class _PrivateChatViewState extends State<PrivateChatView> with PrivateChatViewMixin{


  @override
  void initState() {

    // Sayfa açıldığında listeyi en sona kaydır
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        context.read<PrivateChatViewmodel>().initialize(widget.userId!);
        joinGroup();
        scrollToBottom();
        messageService.onReceivePost = () {
         scrollToBottom();
        };
      },
    );
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    messageService.leaveGroup(widget.connectionId!);

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
                          return PrivateMessageItem(
                            myFullName: value.myFullName!,
                            otherUserFullName: value.otherUserFullName!,
                            receiverUserId: widget.userId!,privateMessageModel: value.messageList[index],);
                        },
                      ),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                            child: CustomTextField(
                              onTap: scrollToBottom,
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


