import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';
import 'package:moto_kent/utils/data_objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGroupsViewmodel extends ChangeNotifier {
  List<ChatGroupModel> _groupsList = [];
  List<ChatGroupModel> get groupsList => _groupsList;

  DioService apiService = DioService();

  Future<void> fetchMyChatGroups() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("user_id");
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
