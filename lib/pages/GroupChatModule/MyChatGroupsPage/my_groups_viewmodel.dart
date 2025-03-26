import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_last_message_model.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class MyGroupsViewmodel extends ChangeNotifier {
  List<ChatGroupLastMessageModel> _lastGroupMessageList = [];
  List<ChatGroupLastMessageModel> get lastGroupMessageList =>
      _lastGroupMessageList;

  List<ChatGroupModel> _groupsList = [];
  List<ChatGroupModel> get groupsList => _groupsList;

  IApiService apiService = ApiServiceImpl();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchMyLastGroupMessage() async {
    _isLoading = true;
    notifyListeners();
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response =
        await apiService.getRequest(ApiConstants.getUserChatGroups2(userId!));


    // Dönüşümü doğru şekilde yapın
    if (response.data is List) {
      _lastGroupMessageList = (response.data as List)
          .map((item) => ChatGroupLastMessageModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Unexpected data format: Expected a list');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyChatGroups() async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response =
        await apiService.getRequest(ApiConstants.getUserChatGroups(userId!));

    // Dönüşümü doğru şekilde yapın
    if (response.data is List) {
      _groupsList = (response.data as List)
          .map((item) => ChatGroupModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Unexpected data format: Expected a list');
    }

    notifyListeners();
  }
}
