import"package:flutter/material.dart";
import "package:moto_kent/components/chat_group_item.dart";
import "package:moto_kent/components/custom_app_bar.dart";
import "package:moto_kent/pages/GroupsPage/SearchChatGroupPage/search_chat_group_viewmodel.dart";
import "package:provider/provider.dart";

class SearchChatGroupView extends StatelessWidget {
  const SearchChatGroupView({super.key});

  Future<void> joinChatGroup(int groupId,BuildContext context) async {
    try {
      var response =
      await context.read<SearchChatGroupViewmodel>().joinChatGroup(groupId);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
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

  void joinChatGropShowDialog(int groupId,BuildContext context) {
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
                await joinChatGroup(groupId,context);
              },
              child: const Text("Katıl")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<SearchChatGroupViewmodel>().clearSearchItemList();
      },
      child: Scaffold(
          appBar:  CustomAppBar(title: "Sohbet Grubu Arayın...",),
          body: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                hintText: "Search..."),
                            onChanged: (value) {
                              context.read<SearchChatGroupViewmodel>().fetchGroups(value);
                            },
                          ),
                        ),
                        const Icon(Icons.search)
                      ]
                  ),
                ),
              ),
              Flexible(
                child: Consumer<SearchChatGroupViewmodel>(
                  builder: (context, value, child) => ListView.builder(

                    itemCount: value.searchItemList.length,
                    itemBuilder: (context, index) => Padding(

                      padding: const EdgeInsets.all(8.0),
                      child: ChatGroupItem(
                        amIAdmin:value.searchItemList[index].amIAdmin ,
                        chatGroupModel: value.searchItemList[index],
                        onPressed: () {
                          joinChatGropShowDialog(value.searchItemList[index].chatGroupId!,context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
