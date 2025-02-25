import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
class SendMessageViewmodel2 extends ChangeNotifier{
  IApiService apiService = ApiServiceImpl();

  final List<types.Message> _messageList=[];
  List<types.Message> get messageList=>_messageList;

  String? _groupId;
  String? get groupId=>_groupId;

  Future<Response> sendMessage(Object object) async {
    var response = await apiService.postRequest(ApiConstants.senMessageChatGroups, object);
    return response;
  }

  Future<void> fetchMessageList(int groupId) async {
    String? userId=await LocalStorageImpl().getValue<String>("user_id");
    var response = await apiService.getRequest(ApiConstants.getMessagesChatGroup(groupId,userId!));
    // Dönüşümü doğru şekilde yapın
    if (response.data is List) {
      for (var element in (response.data as List)) {
        var model=ChatGroupMessageModel.fromJson(element);
        final textMessage = types.TextMessage(
          author: types.User(id: model.senderUserId!),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: "",
          text: model.content!,
        );
        _messageList.insert(0, textMessage);
      }
          
    } else {
      throw Exception('Unexpected data format: Expected a list');
    }

    notifyListeners();
  }

  Future<void> addLastMessage(types.Message value) async {
    _messageList.add(value);
    notifyListeners();
  }

//"groupId" -> "ca5fdea3-f583-47bf-a279-81a17bbdaf32"



}