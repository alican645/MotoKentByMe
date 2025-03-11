class PrivateConversationModel {
  String? userId;
  String? fullName;
  String? profilePhotoPath;
  String? lastMessage;
  DateTime? lastMessageTime;

  PrivateConversationModel(
      {this.userId,
        this.fullName,
        this.profilePhotoPath,
        this.lastMessage,
        this.lastMessageTime});

  PrivateConversationModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    profilePhotoPath = json['profilePhotoPath'];
    lastMessage = json['lastMessage'];
    lastMessageTime = DateTime.tryParse(json['lastMessageTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['profilePhotoPath'] = this.profilePhotoPath;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageTime'] = this.lastMessageTime!.toIso8601String();
    return data;
  }
}