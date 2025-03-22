import 'package:flutter/material.dart';
import 'package:moto_kent/pages/GroupChatModule/SearchChatGroupPage/search_chat_group_view.dart';
import 'package:moto_kent/pages/GroupChatModule/SearchChatGroupPage/search_chat_group_viewmodel.dart';
import 'package:provider/provider.dart';

mixin SearchChatGroupViewMixin on State<SearchChatGroupView> {
  Future<void> joinChatGroup(int groupId) async {
    try {
      var response = await context
          .read<SearchChatGroupViewmodel>()
          .joinRequestChatGroup(groupId);
      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Katılma İsteği Gönderildi"),
          ),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(response.data),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(e.toString()),
        ),
      );
    }
  }

  void joinChatGropShowDialog(int groupId, BuildContext context) {
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
}
