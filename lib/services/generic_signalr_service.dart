import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';


class GenericSignalRService {
  late HubConnection _connection;

  final String endpoint;
  final String methodName;
  GenericSignalRService({ required this.endpoint,required this.methodName});

  /// Gelen veriyi işlemek için bir callback
  Function(List<Object?> arguments)?  onReceiveMessage;
  VoidCallback? onReceiveMethod;


  // Token'in geçerliliğini kontrol eden fonksiyon
  Future<bool> isTokenExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token == null) return true; // Eğer token yoksa geçersiz
    return JwtDecoder.isExpired(token);
  }

  // Token yenileyen fonksiyon
  Future<void> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');
    String? accessToken = prefs.getString('jwt_token');

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

      await prefs.setString('jwt_token', newAccessToken);
      await prefs.setString('refresh_token', newRefreshToken);
    } else {
      throw Exception('Token yenileme başarısız oldu: ${response.statusCode}');
    }
  }

  // Token alıp doğrulama işlemi
  Future<String> ensureValidToken() async {
    if (await isTokenExpired()) {
      await refreshToken();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('Token alınamadı.');
    }
    return token;
  }

  Future<void> initializeSignalR() async {
    String token = await ensureValidToken();
    MessageHeaders headers = MessageHeaders();
    Logger.root.level = Level.ALL;


    headers.setHeaderValue("Content-Type", "application/json");
    headers.setHeaderValue("Authorization", "Bearer $token");
    // Hub bağlantısını başlat
    _connection = HubConnectionBuilder()
        .withUrl(endpoint,
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


    // Gelen mesajı dinle ve callback'e yönlendir
    _connection.on(methodName, (arguments) {
      if (onReceiveMessage != null && arguments!=null) {
        onReceiveMessage!(arguments);
      }

      if(onReceiveMethod!=null){
        onReceiveMethod!.call();
      }
    });

    try {
      await _connection.start();
      print("SignalR bağlantısı başarılı.");
    } catch (e) {
      print("SignalR bağlantı hatası: $e");
    }
  }

  void dispose() {
    _connection.stop();
  }
}