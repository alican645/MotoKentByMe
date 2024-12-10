import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/models/user_photos_model.dart';
import 'package:moto_kent/services/api_service.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class ProfileViewmodel extends ChangeNotifier {
  final DioService _dio = DioService();
  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  UserPhotosModel? _userPhotosModel ;
  UserPhotosModel? get userPhotosModel=>_userPhotosModel;

  UserModel? _userModel;
  UserModel? get userModel=>_userModel;



  Future<void>fetchUserPhoto3(String guid) async{
    _isCompleted=false;
    notifyListeners();
    var response= await DioService().getRequest('${ApiConstants.getUserPhotosEndpoint}?userId=$guid');
    _userPhotosModel=UserPhotosModel.fromJson(response.data);
    _isCompleted=false;
    notifyListeners();
  }

  Future<void> fetchUserProfile(String guid) async {
    _isCompleted =false;
    notifyListeners();
    var response = await _dio.getRequest('${ApiConstants.userProfileEndpoint}/$guid');
    _userModel=UserModel.fromJson(response.data);
    _isCompleted=true;
    notifyListeners();
  }

  Future<void> uploadPhoto(String guid,XFile photo) async {
    await _dio.uploadPhoto(ApiConstants.uploadPhotoEndpoint, photo, {'userId': guid});
    fetchUserPhoto3(guid);
  }




}
