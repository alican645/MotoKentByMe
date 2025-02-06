import 'package:flutter/material.dart';
import 'package:moto_kent/components/chat_group_item.dart';

import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/widgets/bottom_butons_bar.dart';
import 'package:provider/provider.dart';

class ChatGroupsView extends StatefulWidget {
  const ChatGroupsView({super.key});
  @override
  State<ChatGroupsView> createState() => _ChatGroupsViewState();
}

class _ChatGroupsViewState extends State<ChatGroupsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<ChatGroupsViewmodel>(context, listen: false);
      viewModel.fetchChatGropsList();
    });
  }

  Future<void> joinChatGroup(int groupId) async {
    try {
      var response = await context
          .read<ChatGroupsViewmodel>()
          .joinRequestChatGroup(groupId);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Katılma İsteği Gönderildi"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            backgroundColor: Colors.orange,
            content: Text(response.data),
          ),
        );
        
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            backgroundColor: Colors.orange,
            content: Text(e.toString()),
          ),
        );
    }
  }

  void joinChatGropShowDialog(int groupId) {
    showDialog(
      context: context,
      builder: (joinChatGropShowDialogContext) => AlertDialog(
        title: const Text("Bu gruba katılmak ister misiniz?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(joinChatGropShowDialogContext);
              },
              child: const Text("İptal")),
          TextButton(
              onPressed: () async {
                Navigator.pop(joinChatGropShowDialogContext);
                await joinChatGroup(groupId);
              },
              child: const Text("Katıl")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.05, right: width * 0.05, top: width * 0.01),
            child: Consumer<ChatGroupsViewmodel>(
              builder: (context, value, child) => Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: value.groupsList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.50),
                        child: ChatGroupItem(
                          amIAdmin: value.groupsList[index].amIAdmin,
                          chatGroupModel: value.groupsList[index],
                          onPressed: () {
                            joinChatGropShowDialog(
                                value.groupsList[index].chatGroupId!);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const BottomButonsBar()
      ],
    );
  }
}
