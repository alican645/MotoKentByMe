
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferences? _preferences;

  // Singleton Pattern
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
  factory SharedPreferencesHelper() => _instance;

  SharedPreferencesHelper._internal();

  // SharedPreferences başlat
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Veri yazma işlemi (Generic)
  Future<T?> getValue<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (T == String) return prefs.getString(key) as T?;
    if (T == int) return prefs.getInt(key) as T?;
    if (T == bool) return prefs.getBool(key) as T?;
    if (T == double) return prefs.getDouble(key) as T?;
    if (T == List<String>) return prefs.getStringList(key) as T?;
    return null;
  }

  Future<void> setValue<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is int) await prefs.setInt(key, value);
    if (value is bool) await prefs.setBool(key, value);
    if (value is double) await prefs.setDouble(key, value);
    if (value is List<String>) await prefs.setStringList(key, value);
  }

  /// Anahtara bağlı değeri sil
  Future<void> remove(String key) async {
    if (_preferences == null) return;

    await _preferences!.remove(key);
  }

  /// Tüm verileri temizle
  Future<void> clearAll() async {
    if (_preferences == null) return;

    await _preferences!.clear();
  }

  /// Anahtarın var olup olmadığını kontrol et
  bool containsKey(String key) {
    if (_preferences == null) return false;

    return _preferences!.containsKey(key);
  }
}
