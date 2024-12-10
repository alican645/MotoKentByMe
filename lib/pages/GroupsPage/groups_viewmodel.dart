import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';
import 'package:moto_kent/utils/data_objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatGroupsViewmodel extends ChangeNotifier {
  List<ChatGroupModel> _groupsList = [];
  List<ChatGroupModel> get groupsList => _groupsList;

  bool _showNewChatGroups = false;
  bool get showNewChatGroups => _showNewChatGroups;
  void changeNewChatGroups(){
    _showNewChatGroups=!_showNewChatGroups;
    notifyListeners();
  }

  DioService apiService = DioService();

  Future<void> fetchChatGropsList() async {
    var response = await apiService.getRequest(ApiConstants.getAllChatGroups);


    if(response.statusCode==200){// Dönüşümü doğru şekilde yapın
      if (response.data is List) {
        _groupsList = (response.data as List)
            .map((item) => ChatGroupModel.fromJson(item))
            .toList();

      } else {
        throw Exception('Unexpected data format: Expected a list');
      }
      notifyListeners();
      _showNewChatGroups=false;
    }

  }

  Future<Response> joinChatGroup(String groupId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId= prefs.getString("user_id");
    var object=DataObjects.joinGroup(groupId, userId!);
    var response=await apiService.postRequest(ApiConstants.joinChatGroups,object);
    return response;
  }
}
//8a7480f4-dad5-48c5-dd3a-08dd14cd563e
