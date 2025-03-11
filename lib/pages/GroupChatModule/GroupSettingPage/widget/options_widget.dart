
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class OptionsWidget extends StatefulWidget {
  const OptionsWidget({super.key, 
  required this.amIAdmin,
  required this.onLeaveGroup,
  required this.onReportGroup,
  required this.onShareGroup,

  });

  final bool amIAdmin;
  final VoidCallback? onLeaveGroup;
  final VoidCallback? onReportGroup;
  final VoidCallback? onShareGroup;

  @override
  State<OptionsWidget> createState() => _OptionsWidgetState();
}

class _OptionsWidgetState extends State<OptionsWidget> {
  static const MenuItem _share= MenuItem(text: "Grubu Paylaş", icon: Icons.share);
  static const MenuItem _report=  MenuItem(text: "Grubu Şikayet Et", icon: Icons.report_gmailerrorred_sharp);
  static const MenuItem _leave=  MenuItem(text: "Grubtan Ayrıl", icon: Icons.logout);
  static const MenuItem _delete=  MenuItem(text: "Grubu Sil", icon: Icons.delete);
  late List<MenuItem> itemList;

  @override
  void initState() {
    super.initState();
    itemList = [
      _share, _report, widget.amIAdmin ? _delete : _leave
    ];

  }
  

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
              widget.onShareGroup!();
              break;
            case _report:
              widget.onReportGroup!();
              break;
            case _leave || _delete:
              widget.onLeaveGroup!();
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

