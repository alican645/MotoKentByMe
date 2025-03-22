import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class MyAppSettingsViewmodel extends ChangeNotifier {
  IApiService _apiService = ApiServiceImpl();

  UserModel2? _userModel;
  UserModel2? get userModel => _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadProfileData() async {
    _isLoading = false;
    notifyListeners();
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await _apiService
        .getRequest(ApiConstants.getMyEditableProfileData(userId!));
    if (response.statusCode == 200) {
      _userModel = UserModel2.fromJson(response.data);
    }
    _isLoading = true;
    notifyListeners();
  }

  void logOut(BuildContext context) {
    LocalStorageImpl().remove("username");
    LocalStorageImpl().remove("password");
    context.go(AppRoutes.loginPage);
  }
}
