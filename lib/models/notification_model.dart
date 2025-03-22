class NotificationModel {
  int? id;
  int? type;
  bool? isRead;
  bool? isOperationDone;
  String? content;
  String? targetUserId;
  int? relatedEntityId;
  Payload? payload;

  NotificationModel(
      {this.type,
      this.id,
      this.isRead,
      this.isOperationDone,
      this.content,
      this.targetUserId,
      this.relatedEntityId,
      this.payload});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    isRead = json['isRead'];
    isOperationDone = json['isOperationDone'];
    content = json['content'];
    targetUserId = json['targetUserId'];
    relatedEntityId = json['relatedEntityId'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['isRead'] = this.isRead;
    data['isOperationDone'] = this.isOperationDone;
    data['content'] = this.content;
    data['targetUserId'] = this.targetUserId;
    data['relatedEntityId'] = this.relatedEntityId;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}

class Payload {
  String? userId;
  String? groupName;
  int? chatGroupId;
  String?connectionId;
  int?privateConversationId;

  Payload({this.userId, this.chatGroupId});

  Payload.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    connectionId = json['connectionId'];
    privateConversationId = json['privateConversationId'];
    chatGroupId = json['chatGroupId'];
    groupName = json['groupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['chatGroupId'] = this.chatGroupId;
    data['privateConversationId'] = this.privateConversationId;
    data['chatGroupId'] = this.chatGroupId;
    data['groupName'] = this.groupName;
    return data;
  }
}
