import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/private_message_model.dart';
import 'package:moto_kent/pages/AppBarModule/PrivateChatPage/private_chat_viewmodel.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRMessageService2 {
  late HubConnection _connection;
  final VoidCallback? onMessageReceived;
  final VoidCallback? onGroupJoined;
  final VoidCallback? onGroupLeft;
  final PrivateChatViewmodel? vm;

  SignalRMessageService2({
    this.onMessageReceived,
    this.onGroupJoined,
    this.onGroupLeft,
    this.vm
  });

  VoidCallback? onReceivePost;
  late Logger _logger;
  //late StreamSubscription<LogRecord> _logMessagesSub;

  // Token'in geçerliliğini kontrol eden fonksiyon
  Future<bool> isTokenExpired() async {

    String? token =await LocalStorageImpl().getValue<String>('jwt_token');
    if (token == null) return true; // Eğer token yoksa geçersiz
    return JwtDecoder.isExpired(token);
  }

  // Token yenileyen fonksiyon
  Future<void> refreshToken() async {

    String? refreshToken =await LocalStorageImpl().getValue<String>('refresh_token');
    String? accessToken =await LocalStorageImpl().getValue<String>('jwt_token');

    if (refreshToken == null || accessToken == null) {
      throw Exception('Token bulunamadı.');
    }

    final response = await Dio().post(
      ApiConstants.refreshTokenEndpoint,
      data: {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      await LocalStorageImpl().setValue<String>('jwt_token', newAccessToken);
      await LocalStorageImpl().setValue<String>('refresh_token', newRefreshToken);
    } else {
      throw Exception('Token yenileme başarısız oldu: ${response.statusCode}');
    }
  }

  // Token alıp doğrulama işlemi
  Future<String> ensureValidToken() async {
    if (await isTokenExpired()) {
      await refreshToken();
    }

    String? token =await LocalStorageImpl().getValue<String>('jwt_token');
    if (token == null) {
      throw Exception('Token alınamadı.');
    }
    return token;
  }

  Future<void> initializeSignalR(String hubUrl) async {
    String token = await ensureValidToken();
    MessageHeaders headers = MessageHeaders();
    Logger.root.level = Level.ALL;

    _logger = Logger("SignalRMessageService");
    headers.setHeaderValue("Content-Type", "application/json");
    headers.setHeaderValue("Authorization", "Bearer $token");
    // Hub bağlantısını başlat
    _connection = HubConnectionBuilder()
        .withUrl(hubUrl,
        options: HttpConnectionOptions(
            headers: headers,
            accessTokenFactory: () async=>
            "Bearer $token"

        ))
        .withAutomaticReconnect()
        .configureLogging(Logger("SignalR - hub"))
        .build();

    // Bağlantı kapandığında çağrılacak geri çağırım
    _connection.onclose(({Exception? error}) {
      if (error != null) {
        print("SignalR bağlantısı kapandı: ${error.toString()}");
      } else {
        print("SignalR bağlantısı kapandı.");
      }
    });


    _connection.on("ChatMessage", (arguments) async {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final json = arguments[0] as Map<String, dynamic>;
          PrivateMessageModel message = PrivateMessageModel.fromJson(json);
          vm?.addLastMessage(message);
          onReceivePost?.call();
          print("Yeni mesaj alındı: ${message.messageContent}");
        } catch (e) {
          print("Mesaj işlenirken hata: $e");
        }
      }
    });

    // Bir kullanıcı gruba katıldığında çağrılır
    _connection.on("CreateGroupChatConnection", (arguments) {
      print("Bir kullanıcı gruba katıldı: $arguments");
      onGroupJoined?.call();
    });

    // Bir kullanıcı gruptan ayrıldığında çağrılır
    _connection.on("BrokeGroupChatConnection", (arguments) {
      print("Bir kullanıcı gruptan ayrıldı: $arguments");
      onGroupLeft?.call();
    });

    try {
      await _connection.start();
      print("SignalR bağlantısı başarılı.");
    } catch (e) {
      print("SignalR bağlantı hatası: $e");
    }
  }


  Future<void> joinGroup(String groupId) async {
    if (_connection.state == HubConnectionState.Connected) {
      try {
        await _connection.invoke("CreateGroupChatConnection", args: [groupId]);
        print("Gruba katılma işlemi başarılı: $groupId");
      } catch (e) {
        print("Gruba katılma hatası: $e");
      }
    } else {
      print("SignalR bağlantısı aktif değil.");
    }
  }

  /// Kullanıcıyı bir gruptan çıkar
  Future<void> leaveGroup(String groupId) async {
    if (_connection.state == HubConnectionState.Connected) {
      try {
        await _connection.invoke("BrokeGroupChatConnection", args: [groupId]);
        print("Gruptan ayrılma işlemi başarılı: $groupId");
      } catch (e) {
        print("Gruptan ayrılma hatası: $e");
      }
    } else {
      print("SignalR bağlantısı aktif değil.");
    }
  }

  /// Bağlantıyı durdur
  void dispose() {
    _connection.stop();
  }
}
