
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
  Future<void> setValue<T>(String key, T value) async {
    if (_preferences == null) return;

    if (value is String) {
      await _preferences!.setString(key, value);
    } else if (value is int) {
      await _preferences!.setInt(key, value);
    } else if (value is double) {
      await _preferences!.setDouble(key, value);
    } else if (value is bool) {
      await _preferences!.setBool(key, value);
    } else if (value is List<String>) {
      await _preferences!.setStringList(key, value);
    } else {
      throw UnsupportedError("Bu veri tipi desteklenmiyor: ${T.runtimeType}");
    }
  }

  /// Veri okuma işlemi (Generic)
  T? getValue<T>(String key) {
    if (_preferences == null) return null;

    Object? value = _preferences!.get(key);

    if (value is T) {
      return value;
    }
    return null;
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
/*
1. SharedPreferencesHelper'ı Başlatma
init fonksiyonunu uygulamanızın başında bir kere çağırmanız gerekiyor.

dart
Kodu kopyala
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().init();
  runApp(MyApp());
}
2. Veri Yazma

final sharedPrefs = SharedPreferencesHelper();

// String
await sharedPrefs.setValue<String>("username", "JohnDoe");

// Integer
await sharedPrefs.setValue<int>("age", 30);

// Double
await sharedPrefs.setValue<double>("height", 5.9);

// Boolean
await sharedPrefs.setValue<bool>("isLoggedIn", true);

// List<String>
await sharedPrefs.setValue<List<String>>("favorite_colors", ["Red", "Green"]);
3. Veri Okuma

// String
String? username = sharedPrefs.getValue<String>("username");

// Integer
int? age = sharedPrefs.getValue<int>("age");

// Double
double? height = sharedPrefs.getValue<double>("height");

// Boolean
bool? isLoggedIn = sharedPrefs.getValue<bool>("isLoggedIn");

// List<String>
List<String>? colors = sharedPrefs.getValue<List<String>>("favorite_colors");

print("Username: $username, Age: $age, Height: $height, Logged In: $isLoggedIn");
print("Favorite Colors: $colors");
4. Değer Silme
dart
Kodu kopyala
await sharedPrefs.remove("username");
5. Tüm Verileri Silme
dart
Kodu kopyala
await sharedPrefs.clearAll();
6. Anahtar Kontrolü
dart
Kodu kopyala
bool hasKey = sharedPrefs.containsKey("username");
print("Username anahtarı var mı? $hasKey");
*/

