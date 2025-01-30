import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/models/private_message_model.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';


class PrivateChatViewmodel extends ChangeNotifier{


  final DioService _dio = DioService();

  UserModel? _userModel;
  UserModel? get userModel=>_userModel;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;
  List<PrivateMessageModel> _messageList=[];
  List<PrivateMessageModel> get messageList=>_messageList;

  Future<void> fetchMessageList(String user1Id,String user2Id) async {
    var response = await _dio.getRequest(ApiConstants.getPrivateMessagesByPrivateConversationId(user1Id, user2Id));
    // Dönüşümü doğru şekilde yapın
    if (response.data is List) {

      _messageList = (response.data as List)
          .map((item) => PrivateMessageModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Unexpected data format: Expected a list');
    }

  }

  Future<UserModel> fetchUserProfile(String guid) async {
    _userModel = null;

    var response =
    await _dio.getRequest('${ApiConstants.userProfileEndpoint}/$guid');
    _userModel = UserModel.fromJson(response.data);
    return _userModel!;
  }


  Future<Response> sendMessage(Object object) async {
    var response = await _dio.postRequest(ApiConstants.sendMessageToUser, object);
    return response;
  }


  Future<void> addLastMessage(PrivateMessageModel value) async {
    _messageList.add(value);
    notifyListeners();
  }

  Future<void> initialize(String user2Id) async{
    _isLoading=false;
    notifyListeners();
    String? senderUserId=await SharedPreferencesHelper().getValue<String>("user_id");

      await fetchUserProfile(user2Id);
      await fetchMessageList(senderUserId!,user2Id);


    _isLoading=true;
    notifyListeners();

  }

}