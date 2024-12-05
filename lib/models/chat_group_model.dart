class ChatGroupModel {
  int? id;
  String? uniqueId;
  String? name;
  String? groupDescription;
  String? groupIconPath;
  String? groupAdminUserId;
  int? maxMemberCount;
  int? currentMemberCount;

  ChatGroupModel(
      {this.id,
        this.uniqueId,
        this.name,
        this.groupDescription,
        this.groupIconPath,
        this.groupAdminUserId,
        this.maxMemberCount,
        this.currentMemberCount});

  ChatGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['uniqueId'];
    name = json['name'];
    groupDescription = json['groupDescription'];
    groupIconPath = json['groupIconPath'];
    groupAdminUserId = json['groupAdminUserId'];
    maxMemberCount = json['maxMemberCount'];
    currentMemberCount = json['currentMemberCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uniqueId'] = uniqueId;
    data['name'] = name;
    data['groupDescription'] = groupDescription;
    data['groupIconPath'] = groupIconPath;
    data['groupAdminUserId'] = groupAdminUserId;
    data['maxMemberCount'] = maxMemberCount;
    data['currentMemberCount'] = currentMemberCount;
    return data;
  }
}
