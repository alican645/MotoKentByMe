import "package:flutter/material.dart";
import "package:moto_kent/components/chat_group_item.dart";
import "package:moto_kent/components/custom_app_bar.dart";
import "package:moto_kent/pages/GroupChatModule/SearchChatGroupPage/search_chat_group_view_mixin.dart";
import "package:moto_kent/pages/GroupChatModule/SearchChatGroupPage/search_chat_group_viewmodel.dart";
import "package:provider/provider.dart";

class SearchChatGroupView extends StatefulWidget {
  const SearchChatGroupView({super.key});

  @override
  State<SearchChatGroupView> createState() => _SearchChatGroupViewState();
}

class _SearchChatGroupViewState extends State<SearchChatGroupView>
    with SearchChatGroupViewMixin {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<SearchChatGroupViewmodel>().clearSearchItemList();
      },
      child: Scaffold(
          appBar: CustomAppBar(
            title: "Sohbet Grubu Arayın...",
          ),
          body: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(children: [
                    Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Search..."),
                        onChanged: (value) {
                          context
                              .read<SearchChatGroupViewmodel>()
                              .fetchGroups(value);
                        },
                      ),
                    ),
                    const Icon(Icons.search)
                  ]),
                ),
              ),
              Flexible(
                child: Consumer<SearchChatGroupViewmodel>(
                  builder: (context, value, child) => ListView.builder(
                    itemCount: value.searchItemList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChatGroupItem(
                        amIAdmin: value.searchItemList[index].amIAdmin,
                        chatGroupModel: value.searchItemList[index],
                        onPressed: () {
                          joinChatGropShowDialog(
                              value.searchItemList[index].chatGroupId!,
                              context);
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
