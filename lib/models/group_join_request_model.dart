
class GroupJoinRequestModel {
  String? userId;
  int? chatGroupId;
  bool? isAccept;
  int? notificationId;

  GroupJoinRequestModel({this.userId,this.notificationId, this.chatGroupId,this.isAccept});

  GroupJoinRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    notificationId = json['notificationId'];
    chatGroupId = json['chatGroupId'];
    isAccept = json['isAccept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['notificationId'] = notificationId;
    data['chatGroupId'] = chatGroupId;
    data['isAccept'] = isAccept;
    return data;
  }
}