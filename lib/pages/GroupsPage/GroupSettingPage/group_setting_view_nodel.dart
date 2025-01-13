import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';


class GroupSettingViewmodel extends ChangeNotifier{
  final DioService _dioService=DioService();

  ChatGroupModel? _chatGroupModel;
  ChatGroupModel? get chatGroupModel=>_chatGroupModel;


  Future<ChatGroupModel?> fetchGroupData(String groupId) async {

    var response= await _dioService.getRequest(ApiConstants.getChatGroupByGroupId(groupId));
    if(response.statusCode==200){
      if(response.data is Map<String,dynamic>){
        _chatGroupModel=ChatGroupModel.fromJson(response.data);
        print("object");
      }
      return _chatGroupModel;
    }
    return _chatGroupModel;
  }

  Future<Response> leaveGroup(Object data) async {
    var response = await _dioService.postRequest(ApiConstants.leaveChatGroup, data);
    if(response.statusCode==200){
      return response;
    }
    return response;
  }



}