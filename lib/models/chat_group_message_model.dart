class ChatGroupMessageModel {
  String? groupId;
  String? senderUserId;
  String? senderUserName;
  String? content;
  DateTime? sentAt;

  ChatGroupMessageModel(
      {this.groupId,
        this.senderUserId,
        this.senderUserName,
        this.content,
        this.sentAt});

  ChatGroupMessageModel.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    senderUserId = json['senderUserId'];
    senderUserName = json['senderUserName'];
    content = json['content'];
    sentAt = DateTime.tryParse(json['sentAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupId'] = groupId;
    data['senderUserId'] = senderUserId;
    data['senderUserName'] = senderUserName;
    data['content'] = content;
    data['sentAt'] = sentAt?.toIso8601String();
    return data;
  }
}