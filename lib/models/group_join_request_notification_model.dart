class GroupJoinRequestNotificationModel {
  String? userId;
  String? userFullName;
  int? chatGroupId;
  String? chatGroupName;

  GroupJoinRequestNotificationModel(
      {this.userId, this.userFullName, this.chatGroupId, this.chatGroupName});

  GroupJoinRequestNotificationModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userFullName = json['userFullName'];
    chatGroupId = json['chatGroupId'];
    chatGroupName = json['chatGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userFullName'] = this.userFullName;
    data['chatGroupId'] = this.chatGroupId;
    data['chatGroupName'] = this.chatGroupName;
    return data;
  }
}
