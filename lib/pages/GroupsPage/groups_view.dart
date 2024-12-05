import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/chat_group_item.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_model.dart';

import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/services/signalr_service2.dart';
import 'package:provider/provider.dart';



class ChatGroupsView extends StatefulWidget {
  const ChatGroupsView({super.key});
  @override
  State<ChatGroupsView> createState() => _ChatGroupsViewState();
}

class _ChatGroupsViewState extends State<ChatGroupsView> {
  late SignalRService2 _signalRService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<ChatGroupsViewmodel>(context, listen: false);
      viewModel.fetchChatGropsList();

      // SignalR servisini başlat
      _signalRService = SignalRService2(context);
      _signalRService.initializeSignalR();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.05, right: width * 0.05, top: width * 0.01),
      child: Column(
        children: [
          Flexible(
            child: Consumer<ChatGroupsViewmodel>(
              builder: (context, value, child) => ListView.builder(
                itemCount: value.groupsList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.50),
                  child: ChatGroupItem(
                    chatGroupModel: value.groupsList[index],

                   
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_2_outlined,
                      size: 48,
                    ),
                    content: "Gruplarım"),
                _buildButton(
                    onPressed: () {
                      context.go("/chat_groups_page/create_chat_group");
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 48,
                    ),
                    content: "Oluştur"),
                _buildButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 48,
                    ),
                    content: "Ara")
              ],
            ),
          )
        ],
      ),
    );
  }

  GestureDetector _buildButton(
      {required VoidCallback onPressed,
      required Icon icon,
      required String content}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: icon,
          ),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}


