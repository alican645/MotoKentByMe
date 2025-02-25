import 'package:moto_kent/models/user_model.dart';

class ChatGroupModel {

  String? name;
  int? chatGroupId;
  String? groupDescription;
  String? groupImagePath;
  dynamic groupImage;
  String? groupAdminUserId;
  int? maxMemberCount;
  int? currentMemberCount;
  List<UserModel2>? users;
  bool? amIAdmin;

  ChatGroupModel(
      {this.name,
        this.chatGroupId,
        this.groupDescription,
        this.groupImagePath,
        this.groupAdminUserId,
        this.maxMemberCount,
        this.currentMemberCount,
        this.amIAdmin,
        this.groupImage,
        this.users});

  ChatGroupModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    chatGroupId = json['chatGroupId'];
    groupDescription = json['groupDescription'];
    groupImage = json['groupImage'];
    groupImagePath = json['groupImagePath'];
    groupAdminUserId = json['groupAdminUserId'];
    amIAdmin = json['amIAdmin'];
    maxMemberCount = json['maxMemberCount'];
    currentMemberCount = json['currentMemberCount'];
    if (json['users'] != null) {
      users = <UserModel2>[];
      json['users'].forEach((v) {
        users!.add(UserModel2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['chatGroupId'] = chatGroupId;
    data['groupDescription'] = groupDescription;
    data['amIAdmin'] = amIAdmin;
    data['groupImagePath'] = groupImagePath;
    data['groupAdminUserId'] = groupAdminUserId;
    data['groupImage'] = groupImage;
    data['maxMemberCount'] = maxMemberCount;
    data['currentMemberCount'] = currentMemberCount;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


