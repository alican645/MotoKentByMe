import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';
import 'package:moto_kent/constants/data_objects.dart';

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
    String? userId= await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await apiService.getRequest(ApiConstants.getAllChatGroups(userId!));


    if(response.statusCode==200){
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

  Future<Response> joinChatGroup(int groupId) async {

    String? userId= await SharedPreferencesHelper().getValue<String>("user_id");
    var object=DataObjects.joinGroup(groupId, userId!);
    var response=await apiService.postRequest(ApiConstants.joinChatGroup,object);
    return response;
  }

    Future<Response> joinRequestChatGroup(int groupId) async {

    String? userId= await SharedPreferencesHelper().getValue<String>("user_id");
    var object=DataObjects.groupJoinRequest(groupId, userId!);
    var response=await apiService.postRequest(ApiConstants.groupJoinRequest,object);
    return response;
  }
}

