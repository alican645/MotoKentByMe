import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_search_item_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';


class SearchViewmodel extends ChangeNotifier{

  final ApiServiceImpl _dio = ApiServiceImpl();

  List<UserSearchItemModel> _searchItemList=[];
  List<UserSearchItemModel> get searchItemList=>_searchItemList;
  void clearSearchItemList(){
    _searchItemList.clear();
  }


  Future<void> fetchUsers(String parameter) async {
    String? userId=await LocalStorageImpl().getValue<String>("user_id");
    if(parameter=="") return;
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