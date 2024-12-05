import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal();

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

    var url = Uri.parse(ApiConstants.refreshTokenEndpoint);
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      String newAccessToken = jsonResponse['accessToken'];
      String newRefreshToken = jsonResponse['refreshToken'];

      await prefs.setString('jwt_token', newAccessToken);
      await prefs.setString('refresh_token', newRefreshToken);
    } else {
      throw Exception('Token yenileme başarısız oldu.');
    }
  }

  // API isteği yapan genel fonksiyon
  Future<http.Response> makeAuthenticatedRequest(
      String endpoint, String method, {Map<String, dynamic>? body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isExpired = await isTokenExpired();

    if (isExpired) {
      // Token expired ise yenile
      await refreshToken();
    }

    String? token = prefs.getString('jwt_token');
    var url = Uri.parse(endpoint);
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    if (method == 'POST') {
      return await http.post(url, headers: headers, body: jsonEncode(body));
    } else if (method == 'GET') {
      return await http.get(url, headers: headers);
    } else {
      throw Exception('Desteklenmeyen HTTP yöntemi');
    }
  }

  Future<Map<String, dynamic>> makeMultipartRequest(
      String endpoint, XFile photo, Map<String, String> fields) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Oturum açılmadı.');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(fields);

    // Fotoğraf dosyasını isteğe ekle
    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);  // json verisini döndürüyoruz ve işlem burada bitiyor
    } else {
      throw Exception('Fotoğraf yüklenemedi: ${response.statusCode}');
    }
  }

}