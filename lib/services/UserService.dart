// services/user_service.dart
import 'package:smart_event_explorer_frontend/apis/storage/LocalStorage.dart';
import 'package:smart_event_explorer_frontend/models/UserModel.dart';

class UserService {
  final _storage = LocalStorage();

  // Save the user details
  Future<void> saveUser(User user) async {
    await _storage.set("token", user.token);
    await _storage.set("id", user.id);
    await _storage.set("name", user.name);
    await _storage.set("email", user.email);
    await _storage.set("role", user.role);
    await _storage.set("organizerStatus", user.organizerStatus);
    await _storage.set("avatar", user.avatar);
    await _storage.set("bio", user.bio);
  }

  // Retrieve the user details
  Future<User?> getUser() async {
    final token = await _storage.get("token");

    // If no token, user isn't logged in
    if (token == null || token.isEmpty) return null;

    return User(
      token: token,
      id: await _storage.get("id") ?? "",
      name: await _storage.get("name") ?? "??",
      email: await _storage.get("email") ?? "??",
      role: await _storage.get("role") ?? "user",
      organizerStatus: await _storage.get("organizerStatus") ?? "none",
      avatar: await _storage.get("avatar") ?? "",
      bio: await _storage.get("bio") ?? "",
      socialLinks: {},
    );
  }

  // Clear data on logout
  Future<void> clearUser() async {
    await _storage.delete("id");
    await _storage.delete("token");
    await _storage.delete("name");
    await _storage.delete("email");
    await _storage.delete("role");
    await _storage.delete("organizerStatus");
    await _storage.delete("avatar");
    await _storage.delete("bio");
    await _storage.delete("socialLinks");
    await _storage.delete("reason");
  }
}
