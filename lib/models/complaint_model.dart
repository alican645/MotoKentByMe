class ComplaintModel {
  int? id;
  int? complaintReasonId;
  String? complainingUserId;
  int? reportedChatGroupId;
  String? reportedUserId;


  ComplaintModel(
      {this.id,
      this.complainingUserId,
      this.complaintReasonId,
      this.reportedUserId,
        this.reportedChatGroupId,
    });

  ComplaintModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complaintReasonId = json['complaintReasonId'];
    complainingUserId = json['complainingUserId'];
    reportedUserId = json['reportedUserId'];
    reportedChatGroupId = json['reportedChatGroupUniqueId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['complaintReasonId'] = complaintReasonId;
    data['complainingUserId'] = complainingUserId;
    data['reportedUserId'] = reportedUserId;
    data['reportedChatGroupUniqueId'] = reportedChatGroupId;

    return data;
  }
}

