import 'package:moto_kent/models/user_model.dart';

class ChatGroupModel {

  String? name;
  int? chatGroupId;
  String? groupDescription;
  String? groupIconPath;
  String? groupAdminUserId;
  int? maxMemberCount;
  int? currentMemberCount;
  List<UserModel>? users;
  bool? amIAdmin;

  ChatGroupModel(
      {this.name,
        this.chatGroupId,
        this.groupDescription,
        this.groupIconPath,
        this.groupAdminUserId,
        this.maxMemberCount,
        this.currentMemberCount,
        this.amIAdmin,
        this.users});

  ChatGroupModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    chatGroupId = json['chatGroupId'];
    groupDescription = json['groupDescription'];
    groupIconPath = json['groupIconPath'];
    groupAdminUserId = json['groupAdminUserId'];
    amIAdmin = json['amIAdmin'];
    maxMemberCount = json['maxMemberCount'];
    currentMemberCount = json['currentMemberCount'];
    if (json['users'] != null) {
      users = <UserModel>[];
      json['users'].forEach((v) {
        users!.add(UserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['chatGroupId'] = chatGroupId;
    data['groupDescription'] = groupDescription;
    data['amIAdmin'] = amIAdmin;
    data['groupIconPath'] = groupIconPath;
    data['groupAdminUserId'] = groupAdminUserId;
    data['maxMemberCount'] = maxMemberCount;
    data['currentMemberCount'] = currentMemberCount;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


