class ChatGroupMessage {
  String? groupId;
  String? senderUserId;
  String? senderUserName;
  String? content;
  String? sentAt;

  ChatGroupMessage(
      {this.groupId,
        this.senderUserId,
        this.senderUserName,
        this.content,
        this.sentAt});

  ChatGroupMessage.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    senderUserId = json['senderUserId'];
    senderUserName = json['senderUserName'];
    content = json['content'];
    sentAt = json['sentAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['senderUserId'] = this.senderUserId;
    data['senderUserName'] = this.senderUserName;
    data['content'] = this.content;
    data['sentAt'] = this.sentAt;
    return data;
  }
}