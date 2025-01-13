import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/user_search_item_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';


class SearchViewmodel extends ChangeNotifier{

  final DioService _dio = DioService();

  List<UserSearchItemModel> _searchItemList=[];
  List<UserSearchItemModel> get searchItemList=>_searchItemList;
  void clearSearchItemList(){
    _searchItemList.clear();
  }


  Future<void> fetchUsers(String parameter) async {
    String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await _dio.getRequest(ApiConstants.searchUserProfiles(parameter,userId!));
    if(response.statusCode==200){
      _searchItemList=[];
      if(response.data is List){
        _searchItemList=(response.data as List).map((e) => UserSearchItemModel.fromJson(e),).toList();
        notifyListeners();
      }

    }
  }




}