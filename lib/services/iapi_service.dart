import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

abstract class IApiService{
  // Token'in geçerliliğini kontrol eden fonksiyon
  Future<bool> isTokenExpired() ;

  // Token yenileyen fonksiyon
  Future<void> refreshToken() ;

  // Token alıp doğrulama işlemi
  Future<String> ensureValidToken() ;

  // Generic GET fonksiyonu
  Future<Response> getRequest(String endpoint) ;

  // Generic POST fonksiyonu
  Future<Response> postRequest(String endpoint, Object data) ;



  // Generic POST fonksiyonu
  Future<Response> postRequestWithoutToken(String endpoint, Object data) ;

  // Fotoğraf yükleme (Multipart) fonksiyonu
  Future<Response> uploadPhoto(String endpoint, XFile photo, Map<String, String> fields) ;

  Future<Response> getRequestUnit8List(String endpoint) ;
}