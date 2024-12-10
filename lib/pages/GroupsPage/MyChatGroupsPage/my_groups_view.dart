import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:moto_kent/components/chat_group_item.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_viewmodel.dart';

import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/pages/MessagePage/message_view.dart';
import 'package:moto_kent/services/signalr_service2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGroupsView extends StatefulWidget {
  const MyGroupsView({super.key});
  @override
  State<MyGroupsView> createState() => _MyGroupsView();
}

class _MyGroupsView extends State<MyGroupsView> {
  late SignalRService2 _signalRService;

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

                      SharedPreferences prefs =await SharedPreferences.getInstance();
                      String? userId = prefs.getString("user_id");
                      Map<String, dynamic> object = {
                        "userId": userId!,
                        "groupId": value.groupsList[index].uniqueId,
                        "userName": 'Ali Can Aydin'
                      };
                      context.go('/chat_groups_page/my_groups/message_page',
                        extra:object );
                      // context.go('/message_page',
                      //   extra:object );

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
}
