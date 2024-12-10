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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['senderUserId'] = this.senderUserId;
    data['senderUserName'] = this.senderUserName;
    data['content'] = this.content;
    data['sentAt'] = this.sentAt?.toIso8601String();
    return data;
  }
}