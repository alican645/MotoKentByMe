class PrivateMessageModel {
 String? senderId;
 String? receiverId;
 int? privateConversationId;
 String? messageContent;
 String? connectionId;
 DateTime? createdDate;

  PrivateMessageModel({
     this.senderId,
     this.receiverId,
     this.privateConversationId,
     this.messageContent,
    this.createdDate,
    this.connectionId
  });

 PrivateMessageModel.fromJson(Map<String, dynamic> json) {
   privateConversationId = json['groupId'];
   senderId = json['senderId'];
   receiverId = json['receiverId'];
   messageContent = json['messageContent'];
   connectionId = json['connectionId'];
   createdDate = DateTime.tryParse(json['createdDate']);
 }

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = <String, dynamic>{};
   data['privateConversationId'] = privateConversationId;
   data['connectionId'] = connectionId;
   data['senderId'] = senderId;
   data['receiverId'] = receiverId;
   data['messageContent'] = messageContent;
   data['createdDate'] = createdDate?.toIso8601String();
   return data;
 }
}
