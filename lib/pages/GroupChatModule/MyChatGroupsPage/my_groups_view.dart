import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/chat_group_item_2.dart';
import 'package:moto_kent/components/custom_app_bar_widget.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_group_view_mixin.dart';
import 'package:moto_kent/pages/GroupChatModule/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/utils/utils.dart';
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
        //context.read<MyGroupsViewmodel>().fetchMyChatGroups();
        context.read<MyGroupsViewmodel>().fetchMyLastGroupMessage();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showMyChatGroupsDialog();
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.message),
      ),
      appBar: const CustomAppBar22(),
      body: Column(
        children: [
          Flexible(
            child: Consumer<MyGroupsViewmodel>(
              builder: (contextt, value, child) {
                if (value.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: value.lastGroupMessageList.length,
                    itemBuilder: (contextt, index) => InkWell(
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: value.lastGroupMessageList[index]
                                          .amIAdmin ==
                                      null
                                  ? Colors.grey[300]
                                  : (value.lastGroupMessageList[index].amIAdmin!
                                      ? Colors.orange[100]
                                      : Colors.grey[300]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(
                                      "${ApiConstants.baseUrl}/${value.lastGroupMessageList[index].groupPhotoPath}",
                                      scale: 10),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value.lastGroupMessageList[index]
                                            .chatGroupName!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${value.lastGroupMessageList[index].fullName} : ${value.lastGroupMessageList[index].lastMessage}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(Utils.getCurrentTime(value
                                            .lastGroupMessageList[index]
                                            .lastMessageTime!)),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => goToMessagePage(value, index),
                        ));
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
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            content: MyChatGroupsPage(
              groupsList: Provider.of<MyGroupsViewmodel>(context).groupsList,
            ),
          ));
}

class MyChatGroupsPage extends StatefulWidget {
  const MyChatGroupsPage({super.key, required this.groupsList});
  final List<ChatGroupModel> groupsList;

  @override
  State<MyChatGroupsPage> createState() => _MyChatGroupsPageState();
}

class _MyChatGroupsPageState extends State<MyChatGroupsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<MyGroupsViewmodel>().fetchMyChatGroups();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyGroupsViewmodel>(
      builder: (context, value, child) {
        if (value.groupsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          height: MediaQuery.sizeOf(context).height / 2,
          child: ListView.builder(
            itemCount: widget.groupsList.length,
            itemBuilder: (context, index) => ChatGroupItem2(
              group: widget.groupsList[index],
              onTap: () {
                goToMessagePage(index);
              },
            ),
          ),
        );
      },
    );
  }

  void goToMessagePage(int index) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    String? userfullname =
        await LocalStorageImpl().getValue<String>("userfullname");

    Map<String, dynamic> object = {
      "userId": userId!,
      "groupId": widget.groupsList[index].chatGroupId!,
      "userName": userfullname,
      "groupName": widget.groupsList[index].name!,
      "groupIndex": index,
    };
    if (!mounted) return;
    context.push(
        '${AppRoutes.chatGroupsPage}/${AppRoutes.myGroups}/${AppRoutes.messagePage}',
        extra: object);
  }
}
