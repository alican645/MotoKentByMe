import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/private_message_model.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';


class PrivateChatViewmodel extends ChangeNotifier{


  final ApiServiceImpl _dio = ApiServiceImpl();
  final LocalStorage _localStorage=LocalStorageImpl();

  UserModel? _userModel;
  UserModel? get userModel=>_userModel;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  String? _myFullName;
  String? get myFullName=>_myFullName;

  String? _otherUserFullName;
  String? get otherUserFullName=>_otherUserFullName;

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
    String? senderUserId=await _localStorage.getValue<String>("user_id");
    var response =
    await _dio.getRequest(ApiConstants.getProfile(guid, senderUserId!));
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
    String? senderUserId=await _localStorage.getValue<String>("user_id");
    await fetchUserProfile(user2Id);
    await fetchMessageList(senderUserId!,user2Id);
    _myFullName= await LocalStorageImpl().getValue<String>("user_full_name");
    _otherUserFullName=_userModel!.fullName;
    print(_userModel!.userId!);
    _isLoading=true;
    notifyListeners();

  }

}