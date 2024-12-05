import 'package:flutter/material.dart';

import 'package:moto_kent/components/chat_group_item.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_viewmodel.dart';


import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/services/signalr_service2.dart';
import 'package:provider/provider.dart';

class MyGroupsView extends StatefulWidget {
  const MyGroupsView({super.key});
  @override
  State<MyGroupsView> createState() => _MyGroupsView();
}

class _MyGroupsView extends State<MyGroupsView> {
  late SignalRService2 _signalRService;



  void initState(){
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
              builder: (context, value, child) => ListView.builder(
                itemCount: value.groupsList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.50),
                  child: ChatGroupItem(
                    chatGroupModel: value.groupsList[index],
                    onPressed: () {

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

  GestureDetector _buildButton(
      {required VoidCallback onPressed,
        required Icon icon,
        required String content}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: icon,
          ),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}
