
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class EditProfileViewmodel  extends ChangeNotifier{
  IApiService _apiService = ApiServiceImpl();


  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  UserModel2? _userModel;
  UserModel2? get userModel=>_userModel;

  Future<void> fetchData() async {
    _isLoading=false;
    notifyListeners();
    String? userId=await LocalStorageImpl().getValue<String>("user_id");
    var response= await _apiService.getRequest(ApiConstants.getMyEditableProfileData(userId!));
    if(response.statusCode==200){
      _userModel=UserModel2.fromJson(response.data);
    }
    _isLoading=true;
    notifyListeners();
  }


  
}