abstract class LocalStorage {
  // Temel işlemler
  Future<T?> getValue<T>(String key);
  Future<void> setValue<T>(String key, T value);
  Future<void> remove(String key);
  Future<void> clearAll();
  Future<bool> containsKey(String key);

}