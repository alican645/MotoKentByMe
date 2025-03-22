import 'package:moto_kent/models/chat_group_message_model.dart';

class ChatGroupMessageModel2 {
  bool? amIMember;
  List<ChatGroupMessageModel>? items;

  ChatGroupMessageModel2({this.amIMember, this.items});

  ChatGroupMessageModel2.fromJson(Map<String, dynamic> json) {
    amIMember = json['amIMember'];
    if (json['items'] != null) {
      items = <ChatGroupMessageModel>[];
      json['items'].forEach((v) {
        items!.add(ChatGroupMessageModel.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amIMember'] = amIMember;
    data['items'] = items?.map((v) => v.toJson()).toList();
    return data;
  }
}
