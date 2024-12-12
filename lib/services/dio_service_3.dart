import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class DioService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},

    ),
  );

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

    final response = await _dio.post(
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

  // Generic GET fonksiyonu
  Future<Response> getRequest(String endpoint) async {
    try {
      final token = await ensureValidToken();
      return await _dio.get(
        endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception('GET isteğinde hata oluştu: ${e.message}');
    }
  }

  // Generic POST fonksiyonu
  Future<Response> postRequest(String endpoint, Object data) async {
    try {
      final token = await ensureValidToken();
      return await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception('POST isteğinde hata oluştu: ${e.message}');
    }
  }



  // Generic POST fonksiyonu
  Future<Response> postRequestWithoutToken(String endpoint, Object data) async {
    try {

      return await _dio.post(
        endpoint,
        data: data,

      );
    } on DioException catch (e) {
      throw Exception('POST isteğinde hata oluştu: ${e.message}');
    }
  }

  // Fotoğraf yükleme (Multipart) fonksiyonu
  Future<Response> uploadPhoto(String endpoint, XFile photo, Map<String, String> fields) async {
    try {
      final token = await ensureValidToken();

      FormData formData = FormData.fromMap({
        ...fields,
        'photo': await MultipartFile.fromFile(photo.path, filename: photo.name),
      });

      return await _dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception('Fotoğraf yüklenirken hata oluştu: ${e.message}');
    }
  }

  Future<Response> getRequestUnit8List(String endpoint) async {
    try {
      return await _dio.get(
        endpoint,
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioException catch (e) {
      throw Exception('GET isteğinde hata oluştu: ${e.message}');
    }
  }

}
