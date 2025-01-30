import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moto_kent/init/Helpers/shared_preferences_helper.dart';
import 'package:moto_kent/services/iapi_service.dart';
import '../constants/api_constants.dart';

class DioService extends IApiService{
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;
  DioService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},

    ),
  );

  // Token'in geçerliliğini kontrol eden fonksiyon
  @override
  Future<bool> isTokenExpired() async {

    String? token =await SharedPreferencesHelper().getValue<String>('jwt_token');
    if (token == null) return true; // Eğer token yoksa geçersiz
    return JwtDecoder.isExpired(token);
  }

  // Token yenileyen fonksiyon
  @override
  Future<void> refreshToken() async {

    String? refreshToken =await SharedPreferencesHelper().getValue<String>('refresh_token');
    String? accessToken =await SharedPreferencesHelper().getValue<String>('jwt_token');

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

      await SharedPreferencesHelper().setValue<String>('jwt_token', newAccessToken);
      await SharedPreferencesHelper().setValue<String>('refresh_token', newRefreshToken);
    } else {
      throw Exception('Token yenileme başarısız oldu: ${response.statusCode}');
    }
  }

  // Token alıp doğrulama işlemi
  @override
  Future<String> ensureValidToken() async {
    if (await isTokenExpired()) {
      await refreshToken();
    }
    String? token =await SharedPreferencesHelper().getValue<String>('jwt_token');
    if (token == null) {
      throw Exception('Token alınamadı.');
    }
    return token;
  }

  // Generic GET fonksiyonu
  @override
  Future<Response> getRequest(String endpoint) async {
    try {
      final token = await ensureValidToken();
      return await _dio.get(
        endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  // Generic POST fonksiyonu
  @override
  Future<Response> postRequest(String endpoint, Object data) async {
    try {
      final token = await ensureValidToken();
      var response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if(response.statusCode==200 || response.statusCode==201){
        return response;
      }
      return response;
    } on DioException catch (e) {
      if(e.response!=null){
        String errorMessage = e.response?.data??"Sunucu Hatası Oluştu";
        throw Exception(errorMessage);
      }else{
        throw Exception('İstek gönderilirken bir hata oluştu: ${e.message}');
      }

    }
  }



  // Generic POST fonksiyonu
  @override
  Future<Response> postRequestWithoutToken(String endpoint, Object data) async {
    try {

      return await _dio.post(
        endpoint,
        data: data,

      );
    } on DioException catch (e) {
      throw Exception('POST isteğinde hata oluştu: ${e.toString()}');
    }
  }

  // Fotoğraf yükleme (Multipart) fonksiyonu
  @override
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
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception('Fotoğraf yüklenirken hata oluştu: ${e.message}');
    }
  }

  @override
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
