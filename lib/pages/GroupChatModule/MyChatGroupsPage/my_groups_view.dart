import 'package:flutter/material.dart';
import 'package:moto_kent/components/chat_group_item_2.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_group_view_mixin.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:provider/provider.dart';

class MyGroupsView extends StatefulWidget {
  const MyGroupsView({super.key});
  @override
  State<MyGroupsView> createState() => _MyGroupsView();
}

class _MyGroupsView extends State<MyGroupsView> with MyGroupsViewMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        context.read<MyGroupsViewmodel>().fetchMyChatGroups();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<MyGroupsViewmodel>().fetchMyChatGroups();
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.message),
      ),
      appBar: CustomAppBar22(),
      body: Column(
        children: [
          Flexible(
            child: Consumer<MyGroupsViewmodel>(
              builder: (contextt, value, child) {
                if (value.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: value.groupsList.length,
                  itemBuilder: (contextt, index) => ChatGroupItem2(
                    amIAdmin: value.groupsList[index].amIAdmin,
                    group: value.groupsList[index],
                    onTap: () async {
                      goToMessagePage(value, index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void showMyChatGroupsDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Gruplarım", textAlign: TextAlign.center),
          content: Consumer<MyGroupsViewmodel>(
            builder: (context, value, child) {
              if (value.groupsList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: value.groupsList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(value.groupsList[index].name!),
                    onTap: () async {
                      Navigator.pop(context);
                      goToMessagePage(value, index);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
}
