import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class ProfileViewmodel extends ChangeNotifier {
  final ApiServiceImpl _dio = ApiServiceImpl();
  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  UserModel? _userModel;
  UserModel? get userModel=>_userModel;

  Future<void> fetchUserProfile(String guid) async {
    _isCompleted =false;
    notifyListeners();

    var response = await _dio.getRequest(ApiConstants.getMyProfile(guid));
    _userModel=UserModel.fromJson(response.data);
    _isCompleted=true;
    notifyListeners();
  }

  Future<void> uploadPhoto(String guid,XFile photo) async {
    await _dio.uploadPhoto(ApiConstants.uploadPhotoEndpoint, photo, {'userId': guid});
  }




}
