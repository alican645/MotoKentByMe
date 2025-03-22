import 'package:flutter/material.dart';
import 'package:moto_kent/components/chat_group_item_2.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_view_mixin.dart';

import 'package:moto_kent/pages/GroupChatModule/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupChatModule/GroupsPage/widgets/bottom_butons_bar.dart';
import 'package:provider/provider.dart';

class ChatGroupsView extends StatefulWidget {
  const ChatGroupsView({super.key});
  @override
  State<ChatGroupsView> createState() => _ChatGroupsViewState();
}

class _ChatGroupsViewState extends State<ChatGroupsView>
    with ChatGroupsViewMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<ChatGroupsViewmodel>(context, listen: false);
      viewModel.fetchChatGropsList();
    });
  }

  @override
  void joinChatGropShowDialog(int groupId) => showDialog(
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

  @override
  void showScaffoldMessenger(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(message),
        ),
      );

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
