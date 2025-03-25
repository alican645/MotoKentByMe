import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/models/complaint_reason_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class GroupSettingViewmodel extends ChangeNotifier {
  final ApiServiceImpl _dioService = ApiServiceImpl();

  ChatGroupModel? _chatGroupModel;
  ChatGroupModel? get chatGroupModel => _chatGroupModel;

  String? _myUserId;
  String? get myUserId => _myUserId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<ComplaintReasonModel> _list = [];
  List<ComplaintReasonModel> get list => _list;

  Future<void> fetchGroupData(int groupId) async {
    _isLoading = false;
    notifyListeners();
    _myUserId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dioService
        .getRequest(ApiConstants.getChatGroupByGroupId(groupId, _myUserId!));
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        var map = response.data as Map<String, dynamic>;
        _chatGroupModel = ChatGroupModel.fromJson(map);
      }
    }
    _isLoading = true;
    notifyListeners();
  }

  Future<void> fetchComplaintReason() async {
    var response =
        await _dioService.getRequest(ApiConstants.getAllComplaintReasons);
    if (response.data is List) {
      _list = (response.data as List)
          .map(
            (e) => ComplaintReasonModel.fromJson(e),
          )
          .toList();
    }
  }

  Future<Response> leaveGroup(Object data) async {
    var response =
        await _dioService.postRequest(ApiConstants.leaveChatGroup, data);
    if (response.statusCode == 200) {
      return response;
    }
    return response;
  }

  Future<Response> removeUser(Object data) async {
    var response = await _dioService.postRequest(ApiConstants.removeUser, data);
    return response;
  }

  Future<Response> addComplaintChatGroup(Object data) async {
    var response =
        await _dioService.postRequest(ApiConstants.addComplaintChatGroup, data);
    return response;
  }

  Future<Response> addComplaintUser(Object data) async {
    var response =
        await _dioService.postRequest(ApiConstants.addComplaint, data);
    return response;
  }

  Future<Response> startPrivateConversation(String userId2) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dioService.postRequest(
        ApiConstants.createPrivateConversation,
        DataObjects.privateConversationObject(userId!, userId2));
    return response;
  }

  Future<Map<String, dynamic>> initialize(int groupId) async {
    await fetchGroupData(groupId);
    await fetchComplaintReason();
    Map<String, dynamic> result = {
      "chatGroupModel": _chatGroupModel,
      "myUserId": _myUserId
    };
    return result;
  }
}
