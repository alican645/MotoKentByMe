import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/models/user_photos_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

class OtherProfileViewmodel extends ChangeNotifier {
  final DioService _dio = DioService();
  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  bool _isFollow = false;
  bool get isFollow => _isFollow;

  UserPhotosModel? _userPhotosModel;
  UserPhotosModel? get userPhotosModel => _userPhotosModel;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> fetchUserPhoto3(String guid) async {
    _isCompleted = false;
    notifyListeners();
    var response = await DioService()
        .getRequest('${ApiConstants.getUserPhotosEndpoint}?userId=$guid');
    _userPhotosModel = UserPhotosModel.fromJson(response.data);
    _isCompleted = false;
    notifyListeners();
  }

  Future<void> fetchUserProfile(String guid) async {
    _userModel = null;

    notifyListeners();
    var response =
        await _dio.getRequest('${ApiConstants.userProfileEndpoint}/$guid');
    _userModel = UserModel.fromJson(response.data);

    notifyListeners();
  }


  Future<Response> followOrUnfollowUser(Object object, bool isFollow) async {
    String endpoint =
        isFollow ? ApiConstants.followEndpoint : ApiConstants.unfollowEndpoint;
    var response = await _dio.postRequest(endpoint, object);
    return response;
  }

  Future<void> followerRelationshipEndPoint(Object object) async {
    var response = await _dio.postRequest(
        ApiConstants.userFollowerRelationshipEndPoint, object);
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        if ((response.data as Map<String, dynamic>)["relationship"] == true) {
          _isFollow = true;
          notifyListeners();
        } else {
          _isFollow = false;
          notifyListeners();
        }
      }
    }
  }

  Future<Response> startPrivateConversation(String userId2) async{
    String? userId=await SharedPreferencesHelper().getValue<String>("user_id");
    var response = await _dio.postRequest(ApiConstants.createPrivateConversation, DataObjects.privateConversationObject(userId!, userId2));
    return response;
  }

}
