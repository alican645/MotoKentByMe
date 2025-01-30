class ComplaintReasonModel {
  int? id;
  String? complaintReasonContent;

  ComplaintReasonModel({this.id, this.complaintReasonContent});

  ComplaintReasonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complaintReasonContent = json['complaintReasonContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['complaintReasonContent'] = complaintReasonContent;
    return data;
  }
}