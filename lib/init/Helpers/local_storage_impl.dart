
import 'package:moto_kent/init/Helpers/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LocalStorageImpl implements LocalStorage {
    SharedPreferences? _preferences;

  // Singleton Pattern
  static final LocalStorageImpl _instance = LocalStorageImpl._internal();
  factory LocalStorageImpl() => _instance;

  LocalStorageImpl._internal();

  // SharedPreferences başlat
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  
  @override
  Future<void> clearAll()async {
        if (_preferences == null) return;

    await _preferences!.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    if (_preferences == null) return false;

    return _preferences!.containsKey(key);
  }


  @override
  Future<T?> getValue<T>(String key) async {
     final prefs = await SharedPreferences.getInstance();
    if (T == String) return prefs.getString(key) as T?;
    if (T == int) return prefs.getInt(key) as T?;
    if (T == bool) return prefs.getBool(key) as T?;
    if (T == double) return prefs.getDouble(key) as T?;
    if (T == List<String>) return prefs.getStringList(key) as T?;
    return null;
  }



  @override
  Future<void> remove(String key) async {
    if (_preferences == null) return;

    await _preferences!.remove(key);
  }


  @override
  Future<void> setValue<T>(String key, T value) async {
 final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is int) await prefs.setInt(key, value);
    if (value is bool) await prefs.setBool(key, value);
    if (value is double) await prefs.setDouble(key, value);
    if (value is List<String>) await prefs.setStringList(key, value);
  }
}