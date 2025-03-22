import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/notification_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class MyNotificationsViewmodel extends ChangeNotifier {
  List<NotificationModel> _list = [];
  List<NotificationModel> get list => _list;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ApiServiceImpl _dioService = ApiServiceImpl();

  Future<void> fetchList() async {
    _isLoading = false;
    notifyListeners();

    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dioService
        .getRequest(ApiConstants.getAllNotificationByAdminId(userId!));
    if (response.data is List) {
      _list = (response.data as List)
          .map(
            (e) => NotificationModel.fromJson(e),
          )
          .toList();
    }
    _isLoading = true;
    notifyListeners();
  }

  Future<Response> acceptOrReject(Object data, int index) async {
    var response = await _dioService.postRequest(
        ApiConstants.acceptGroupJoinRequest, data);
    if (response.statusCode == 200) {
      removeNotification(index);
    }
    return response;
  }

  Future<Response> operationDone(Object data, int index) async {
    var response =
        await _dioService.postRequest(ApiConstants.operationDone, data);
    return response;
  }

  void removeNotification(int index) {
    _list.removeAt(index);
    notifyListeners();
  }
}
