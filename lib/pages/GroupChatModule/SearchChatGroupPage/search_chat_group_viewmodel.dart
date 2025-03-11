import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class SearchChatGroupViewmodel extends ChangeNotifier {
  final ApiServiceImpl _dio = ApiServiceImpl();

  List<ChatGroupModel> _searchItemList = [];
  List<ChatGroupModel> get searchItemList => _searchItemList;
  void clearSearchItemList() {
    _searchItemList.clear();
  }

  Future<void> fetchGroups(String parameter) async {
    if(parameter=="") return;
    String? userId= await LocalStorageImpl().getValue<String>("user_id");

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


  Future<Response> joinRequestChatGroup(int groupId) async {

    String? userId= await LocalStorageImpl().getValue<String>("user_id");
    var object=DataObjects.groupJoinRequest(groupId, userId!);
    var response=await _dio.postRequest(ApiConstants.groupJoinRequest,object);
    return response;
  }

}
