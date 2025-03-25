import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_message_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class SendMessageViewmodel extends ChangeNotifier {
  IApiService apiService = ApiServiceImpl();

  List<ChatGroupMessageModel> _messageList = [];
  List<ChatGroupMessageModel> get messageList => _messageList;

  String? _groupId;
  String? get groupId => _groupId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _pageIsOpen = false;
  bool get pageIsOpen => _pageIsOpen;

  Future<Response> sendMessage(Object object) async {
    var response =
        await apiService.postRequest(ApiConstants.senMessageChatGroups, object);
    return response;
  }

  Future<void> fetchMessageList(int groupId) async {
    _isLoading = false;
    notifyListeners();
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await apiService
        .getRequest(ApiConstants.getMessagesChatGroup(groupId, userId!));
    // Dönüşümü doğru şekilde yapın
    if (response.data is List) {
      _messageList = (response.data as List)
          .map((item) => ChatGroupMessageModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Unexpected data format: Expected a list');
    }
    _isLoading = true;
    notifyListeners();
  }

  Future<void> fetchMessageList2(int groupId) async {
    _isLoading = false;
    notifyListeners();
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await apiService
        .getRequest(ApiConstants.getMessagesChatGroup(groupId, userId!));
    // Dönüşümü doğru şekilde yapın
    if (response.data is List) {
      _messageList = (response.data as List)
          .map((e) => ChatGroupMessageModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Unexpected data format: Expected a list');
    }
    _isLoading = true;
    notifyListeners();
  }

  Future<void> addLastMessage(ChatGroupMessageModel value) async {
    _messageList.add(value);
    notifyListeners();
  }
}
