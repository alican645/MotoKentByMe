

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class SendMessageViewmodel extends ChangeNotifier{
  DioService apiService = DioService();

  List<ChatGroupMessageModel> _messageList=[];
  List<ChatGroupMessageModel> get messageList=>_messageList;

  String? _groupId;
  String? get groupId=>_groupId;

  Future<Response> sendMessage(Object object) async {
    var response = await apiService.postRequest(ApiConstants.senMessageChatGroups, object);
    return response;
  }

  Future<void> fetchMessageList(String groupId) async {
    var response = await apiService.getRequest(ApiConstants.getMessagesChatGroup(groupId));
    // Dönüşümü doğru şekilde yapın
    if (response.data is List) {
      _messageList = (response.data as List)
          .map((item) => ChatGroupMessageModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Unexpected data format: Expected a list');
    }

    notifyListeners();
  }

  Future<void> addLastMessage(ChatGroupMessageModel value) async {
    _messageList.add(value);
    notifyListeners();
  }

//"groupId" -> "ca5fdea3-f583-47bf-a279-81a17bbdaf32"



}