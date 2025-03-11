

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/app_routes.dart';
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/user_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MyAppSettingsViewmodel extends ChangeNotifier {
  final LocalStorage _localStorage=LocalStorageImpl();
  IApiService _apiService = ApiServiceImpl();

  String? _currentName="";
  String? get currentName=>_currentName;

  String? _currentEmail="";
  String? get currentEmail=>_currentEmail;

  String? _userProfilePhotoPath="";
  String? get userProfilePhotoPath=>_userProfilePhotoPath;

  String? _bio="";
  String? get bio=>_bio;

  UserModel2? _userModel;
  UserModel2? get userModel=>_userModel;



  Future<void> loadProfileData() async {
   _currentEmail=await _localStorage.getValue<String>("username");
   String? userId=await LocalStorageImpl().getValue<String>("user_id");
   var response= await _apiService.getRequest(ApiConstants.getMyEditableProfileData(userId!));
   if(response.statusCode==200){
     _userModel=UserModel2.fromJson(response.data);
     _userProfilePhotoPath=_userModel!.profilePhotoPath;
     _currentName = _userModel!.fullName;
   }
   notifyListeners();
  }
    void logOut(BuildContext context) {
    LocalStorageImpl().remove("username");
    LocalStorageImpl().remove("password");
    context.go(AppRoutes.loginPage);
  }


  bool _isNotificationEnabled = false;
  bool  get isNotificationEnabled =>_isNotificationEnabled ;

  // Bildirim durumunu yükle (yerel tercih + cihaz izni)
  Future<void> loadNotificationStatus() async {
    
    final bool savedPreference =await _localStorage.getValue<bool>('notifications_enabled') ?? false;
    
    // Cihazın bildirim iznini kontrol et
    final PermissionStatus status = await Permission.notification.status;
    
   
    _isNotificationEnabled = savedPreference && status.isGranted;
    notifyListeners();
  }

  // Switch'i toggle etme
  Future<void> toggleNotification(bool value) async {
    if (value) {
      // Erişim izni iste
      final PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        await _localStorage.setValue<bool>('notifications_enabled', true);
      } else {
        // İzin reddedilirse ayarlara yönlendir
        await openAppSettings();
        return;
      }
    } else {
      await _localStorage.setValue<bool>('notifications_enabled', false);
    }

    // Güncel izin durumunu tekrar kontrol et
    final PermissionStatus currentStatus = await Permission.notification.status;
    
   
      _isNotificationEnabled = currentStatus.isGranted && value;
    notifyListeners();
  }
}