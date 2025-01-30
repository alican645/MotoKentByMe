import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class SearchChatGroupViewmodel extends ChangeNotifier {
  final DioService _dio = DioService();

  List<ChatGroupModel> _searchItemList = [];
  List<ChatGroupModel> get searchItemList => _searchItemList;
  void clearSearchItemList() {
    _searchItemList.clear();
  }

  Future<void> fetchGroups(String parameter) async {
    if(parameter=="") return;
    String? userId= await SharedPreferencesHelper().getValue<String>("user_id");

    var response = await _dio
        .getRequest(ApiConstants.searchChatGroups(parameter,userId!));
    if (response.statusCode == 200) {
      _searchItemList = [];
      if (response.data is List) {
        _searchItemList = (response.data as List)
            .map(
              (e) => ChatGroupModel.fromJson(e),
            )
            .toList();
        notifyListeners();
      }
    }
  }

  Future<Response> joinChatGroup(String groupId) async {

    String? userId= await SharedPreferencesHelper().getValue<String>("user_id");
    var object=DataObjects.joinGroup(groupId, userId!);
    var response=await _dio.postRequest(ApiConstants.joinChatGroup,object);
    return response;
  }

}
