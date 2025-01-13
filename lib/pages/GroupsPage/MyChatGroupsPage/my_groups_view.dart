import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/components/chat_group_item.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:provider/provider.dart';

class MyGroupsView extends StatefulWidget {
  const MyGroupsView({super.key});
  @override
  State<MyGroupsView> createState() => _MyGroupsView();
}

class _MyGroupsView extends State<MyGroupsView> {


  @override
  void initState() {
    super.initState();
    context.read<MyGroupsViewmodel>().fetchMyChatGroups();
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
            child: Consumer<MyGroupsViewmodel>(
              builder: (contextt, value, child) => ListView.builder(
                itemCount: value.groupsList.length,
                itemBuilder: (contextt, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.50),
                  child: ChatGroupItem(
                    chatGroupModel: value.groupsList[index],
                    onPressed: () async {

                      goToMessagePage(value, index, context);

                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToMessagePage(MyGroupsViewmodel value, int index, BuildContext context) async {
     String? userId= await SharedPreferencesHelper().getValue<String>("user_id");
    Map<String, String> object = {
      "userId": userId!,
      "groupId": value.groupsList[index].uniqueId!,
      "userName": 'Ali Can Aydin',
      "groupName": value.groupsList[index].name!
    };
    context.push('/chat_groups_page/my_groups/message_page',
        extra: object);

  }
}
