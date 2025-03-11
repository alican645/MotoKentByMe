import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/models/user_photos_model.dart';
import 'package:moto_kent/models/user_rating_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class OtherProfileViewmodel extends ChangeNotifier {
  final ApiServiceImpl _dio = ApiServiceImpl();
  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  bool _isFollow = false;
  bool get isFollow => _isFollow;

  bool _isFirstRate = false;
  bool get isFirstRate => _isFirstRate;

  int _initialRating=0;
  int get initialRating=>_initialRating;

  UserPhotosModel? _userPhotosModel;
  UserPhotosModel? get userPhotosModel => _userPhotosModel;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> fetchUserPhoto3(String guid) async {
    _isCompleted = false;
    notifyListeners();
    var response = await ApiServiceImpl()
        .getRequest('${ApiConstants.getUserPhotosEndpoint}?userId=$guid');
    _userPhotosModel = UserPhotosModel.fromJson(response.data);
    _isCompleted = false;
    notifyListeners();
  }

  Future<void> fetchUserProfile(String guid) async {
    _userModel = null;
    notifyListeners();
    String? userId=await LocalStorageImpl().getValue<String>("user_id");
    var response =
        await _dio.getRequest(ApiConstants.getProfile(guid, userId!));
    _userModel = UserModel.fromJson(response.data);
    _isFirstRate=_userModel!.rating==0?true:false;

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
    String? userId=await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dio.postRequest(ApiConstants.createPrivateConversation, DataObjects.privateConversationObject(userId!, userId2));
    return response;
  }

  Future<bool> rateThisUser(UserRatingModel object) async {
    try{
      String? userId=await LocalStorageImpl().getValue<String>("user_id");
      object.raterUserId=userId!;
      var respoonse =await _dio.postRequest(ApiConstants.createUserRating, object.toJson());
      if(respoonse.statusCode==200){
        return true;
      }else{
        return false;
      }
    }catch(ex){
      return false;
    }
  }

}
