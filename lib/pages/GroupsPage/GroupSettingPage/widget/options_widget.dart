import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moto_kent/App/app_theme.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/complaint_model.dart';
import 'package:moto_kent/pages/GroupsPage/GroupSettingPage/group_setting_view_nodel.dart';
import 'package:moto_kent/pages/GroupsPage/MyChatGroupsPage/my_groups_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:moto_kent/utils/complaint_dialog.dart';
import 'package:provider/provider.dart';

class OptionsWidget extends StatefulWidget {
  const OptionsWidget({super.key, required this.gorupId});

  final String gorupId;
  @override
  State<OptionsWidget> createState() => _OptionsWidgetState();
}

class _OptionsWidgetState extends State<OptionsWidget> {
  static const MenuItem _share= MenuItem(text: "Grubu Paylaş", icon: Icons.share);
  static const MenuItem _report=  MenuItem(text: "Grubu Şikayet Et", icon: Icons.report_gmailerrorred_sharp);
  static const MenuItem _leave=  MenuItem(text: "Grubtan Ayrıl", icon: Icons.logout);
  List<MenuItem> itemList=[
    _share,_report,_leave
  ];

  Future<void> leaveGroup() async {
    String? userId =
        await SharedPreferencesHelper().getValue<String>("user_id");
    if(!mounted) return;
    var response = await context
        .read<GroupSettingViewmodel>()
        .leaveGroup(DataObjects.joinGroup(widget.gorupId, userId!));
    if (response.statusCode == 200) {
      if(!mounted) return;
      await context.read<MyGroupsViewmodel>().fetchMyChatGroups();
      await Future.delayed(const Duration(seconds: 1));
      if(!mounted) return;
      await context.read<ChatGroupsViewmodel>().fetchChatGropsList();
      if(!mounted) return;
      Navigator.popUntil(
          context, (route) => route.settings.name == "my_groups");
    }
  }

  Future<void> reportGroup()async {
    var list =
        Provider
            .of<GroupSettingViewmodel>(context, listen: false)
            .list;
    var selectedID = await ComplaintDialog.show(context: context,reasons:  list);
    String reportedUser = widget.gorupId;
    String? complainingUser = await SharedPreferencesHelper()
        .getValue<String>("user_id");

    var newComplaint = ComplaintModel(
        complainingUserId: complainingUser,
        complaintReasonId: selectedID,
        reportedChatGroupUniqueId: reportedUser);
    try {
      if(!mounted) return;
      var response = await context
          .read<GroupSettingViewmodel>()
          .addComplaintChatGroup(newComplaint.toJson());

      if (response.statusCode == 200) {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppTheme.themeData.primaryColor,
              content: const Text('Grup şikayet edildi.')),
        );
      } else {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                  'Grup şikayet edilirken bir hata ile karşılaşıldı.')),
        );
      }
    }catch(e){
      log("options-reportgroup",error: e.toString());
    }
  }

  Future<void> shareGroup()async{}




  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: SizedBox(
            width: 24, child: SvgPicture.asset("assets/svg/options.svg")),
        items: [
          ...itemList.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: Row(
                children: [
                  Icon(item.icon, color: Colors.black, size: 22),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        onChanged: (item) async {
          switch (item) {
            case _share:
              await shareGroup();
              break;
            case _report:
              await reportGroup();
              break;
            case _leave:
            await leaveGroup();
              break;
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(itemList.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

