import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final BuildContext context;

  PermissionService(this.context);

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog('Depolama izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog('Kamera izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog('Mikrofon izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog('Konum izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }
  }

  Future<void> requestContactsPermission() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      await Permission.contacts.request();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog('Rehber izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }
  }

  Future<void> requestNotificationPermission() async {
    if (Platform.isIOS || Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      } else if (status.isPermanentlyDenied) {
        _showSettingsDialog('Bildirim izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
      }
    }
  }

  Future<void> requestBackgroundLocationPermission() async {
    var status = await Permission.locationAlways.status;
    if (status.isDenied) {
      await Permission.locationAlways.request();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog('Arka plan konum izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }
  }

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
