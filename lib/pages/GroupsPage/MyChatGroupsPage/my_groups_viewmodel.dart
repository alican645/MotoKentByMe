import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class MyGroupsViewmodel extends ChangeNotifier {
  List<ChatGroupModel> _groupsList = [];
  List<ChatGroupModel> get groupsList => _groupsList;

  DioService apiService = DioService();

  Future<void> fetchMyChatGroups() async {

      String? userId =await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await apiService.getRequest(ApiConstants.getUserChatGroups(userId!));

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
