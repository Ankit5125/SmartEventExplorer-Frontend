import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final storage = FlutterSecureStorage();

  Future<String?> get(String key) async {
    return await storage.read(key: key);
  }

  Future<Map<String, String>> getAll() async {
    return await storage.readAll();
  }

  Future<void> set(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    return await storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    return await storage.deleteAll();
  }
}
