import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/chat_group_item.dart';

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

  Future<void> joinChatGroup(String groupId) async {
    try {
      var response =
          await context.read<ChatGroupsViewmodel>().joinChatGroup(groupId);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Gruba Katıldınız"),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  void joinChatGropShowDialog(String groupId) {
    showDialog(
      context: context,
      builder: (joinChatGropShowDialogContext) => AlertDialog(
        title: Text("Bu gruba katılmak ister misiniz?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(joinChatGropShowDialogContext);
              },
              child: Text("İptal")),
          TextButton(
              onPressed: () async {
                Navigator.pop(joinChatGropShowDialogContext);
                await joinChatGroup(groupId);
              },
              child: Text("Katıl")),
        ],
      ),
    );
  }

  Future<void> fethGroupList() async{
    context.read<ChatGroupsViewmodel>().fetchChatGropsList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.05, right: width * 0.05, top: width * 0.01),
      child: Consumer<ChatGroupsViewmodel>(
        builder: (context, value, child) => Column(
          children: [
            Visibility(
              visible: value.showNewChatGroups,
                child: GestureDetector(
                  onTap: ()  async {
                    await fethGroupList();
                  },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.grey[300]
                ),
                child: Center(
                  child: Text("Yeni Grupları Görüntüle"),
                ),
              ),
            )),
            Flexible(
              child: ListView.builder(
                itemCount: value.groupsList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.50),
                  child: ChatGroupItem(
                    chatGroupModel: value.groupsList[index],
                    onPressed: () {
                      joinChatGropShowDialog(value.groupsList[index].uniqueId!);
                    },
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
                      onPressed: () {
                        context.go("/chat_groups_page/my_groups");
                      },
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
