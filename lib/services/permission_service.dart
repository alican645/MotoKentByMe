import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final BuildContext context;
  bool _isRequestingPermission = false; // Tekrar eden istekleri engellemek için bayrak

  PermissionService(this.context);

  Future<void> initializePermissions() async {
    if (_isRequestingPermission) return; // Devam eden istek varsa engelle
    _isRequestingPermission = true;

    try {
      await requestStoragePermission();
      await requestCameraPermission();
      await requestMicrophonePermission();
      await requestLocationPermission();
      await requestContactsPermission();
      await requestNotificationPermission();
      await requestBackgroundLocationPermission();
    } catch (e) {
      debugPrint("İzinler sırasında hata oluştu: $e");
    } finally {
      _isRequestingPermission = false; // Bayrağı sıfırla
    }
  }

  Future<void> requestStoragePermission() async {
    await _requestPermission(
      permission: Permission.storage,
      message: 'Depolama izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.',
    );
  }

  Future<void> requestCameraPermission() async {
    await _requestPermission(
      permission: Permission.camera,
      message: 'Kamera izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.',
    );
  }

  Future<void> requestMicrophonePermission() async {
    await _requestPermission(
      permission: Permission.microphone,
      message: 'Mikrofon izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.',
    );
  }

  Future<void> requestLocationPermission() async {
    await _requestPermission(
      permission: Permission.locationWhenInUse,
      message: 'Konum izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.',
    );
  }

  Future<void> requestContactsPermission() async {
    await _requestPermission(
      permission: Permission.contacts,
      message: 'Rehber izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.',
    );
  }

  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid && Platform.version.compareTo('13') >= 0) {
      await _requestPermission(
        permission: Permission.notification,
        message: 'Bildirim izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.',
      );
    }
  }

  Future<void> requestBackgroundLocationPermission() async {
    var locationStatus = await Permission.locationWhenInUse.status;
    if (locationStatus.isGranted) {
      await _requestPermission(
        permission: Permission.locationAlways,
        message: 'Arka plan konum izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.',
      );
    } else {
      debugPrint("Önce 'locationWhenInUse' izninin verilmesi gerekiyor.");
    }
  }

  // Genel izin isteği işlemi
  Future<void> _requestPermission({
    required Permission permission,
    required String message,
  }) async {
    var status = await permission.status;

    if (status.isDenied) {
      await permission.request();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog(message);
    }
  }

  // Ayarlar açma dialogu
  void _showSettingsDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İzin Gerekli'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Ayarları Aç'),
          ),
        ],
      ),
    );
  }
}
