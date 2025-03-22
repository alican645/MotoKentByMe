class ChatGroupLastMessageModel {
  int? chatGroupId;
  String? chatGroupName;
  String? fullName;
  String? groupPhotoPath;
  String? lastMessage;
  DateTime? lastMessageTime;
  bool? amIAdmin;

  ChatGroupLastMessageModel(
      {this.chatGroupId,
      this.chatGroupName,
      this.fullName,
      this.groupPhotoPath,
      this.amIAdmin,
      this.lastMessage,
      this.lastMessageTime});

  ChatGroupLastMessageModel.fromJson(Map<String, dynamic> json) {
    chatGroupId = json['chatGroupId'];
    chatGroupName = json['chatGroupName'];
    fullName = json['fullName'];
    groupPhotoPath = json['groupPhotoPath'];
    amIAdmin = json['amIAdmin'];
    lastMessage = json['lastMessage'];
    lastMessageTime = DateTime.parse(json['lastMessageTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatGroupId'] = chatGroupId;
    data['chatGroupName'] = chatGroupName;
    data['fullName'] = fullName;
    data['groupPhotoPath'] = groupPhotoPath;
    data['amIAdmin'] = amIAdmin;
    data['lastMessage'] = lastMessage;
    data['lastMessageTime'] = lastMessageTime?.toIso8601String();
    return data;
  }
}
