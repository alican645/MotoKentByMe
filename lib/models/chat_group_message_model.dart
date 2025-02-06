class ChatGroupMessageModel {
  int? chatGroupId;
  String? senderUserId;
  String? senderUserName;
  String? content;
  DateTime? sentAt;

  ChatGroupMessageModel(
      {this.chatGroupId,
        this.senderUserId,
        this.senderUserName,
        this.content,
        this.sentAt});

  ChatGroupMessageModel.fromJson(Map<String, dynamic> json) {
    chatGroupId = json['chatGroupId'];
    senderUserId = json['senderUserId'];
    senderUserName = json['senderUserName'];
    content = json['content'];
    sentAt = DateTime.tryParse(json['sentAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatGroupId'] = chatGroupId;
    data['senderUserId'] = senderUserId;
    data['senderUserName'] = senderUserName;
    data['content'] = content;
    data['sentAt'] = sentAt?.toIso8601String();
    return data;
  }
}