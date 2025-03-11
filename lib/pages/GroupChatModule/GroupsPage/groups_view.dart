import 'package:flutter/material.dart';
import 'package:moto_kent/components/chat_group_item.dart';
import 'package:moto_kent/components/chat_group_item_2.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';

import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/widgets/bottom_butons_bar.dart';
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
    return Scaffold(
      appBar: CustomAppBar22(),
      body: Column(
        children: [
          Flexible(
            child: Consumer<ChatGroupsViewmodel>(
              builder: (context, value, child) => Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: value.groupsList.length,
                      itemBuilder: (context, index) => ChatGroupItem2(
                        group: value.groupsList[index],
                        amIAdmin: value.groupsList[index].amIAdmin,
                        onTap: () {
                          joinChatGropShowDialog(
                              value.groupsList[index].chatGroupId!);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BottomButonsBar()
        ],
      ),
    );
  }
}
