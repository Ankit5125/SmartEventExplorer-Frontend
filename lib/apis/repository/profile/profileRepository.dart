import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_event_explorer_frontend/apis/storage/LocalStorage.dart';
import 'package:smart_event_explorer_frontend/models/UserModel.dart';

class ProfileRepository {
  static final String baseURL = dotenv.env['baseURL'] ?? "http://10.0.2.2:5000";

  Future<User> getUserProfile() async {
    final token = await _getToken();

    try {
      final response = await http.get(
        Uri.parse("$baseURL/api/users/profile"),
        headers: {"x-auth-token": token},
      );

      _handleTokenError(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = jsonDecode(response.body);
        User user = User.fromJson(userDetails);
        print("GET User Profile Successful");
        return user;
      }

      if (response.statusCode == 401) {
        print("GET User Profile Error: ${response.body}");
        return Future.error("AUTH_EXPIRED");
      }

      print("SOMETHING WENT WRONG WHILE GET USER PROFILE!!!");
      return Future.error("SOMETHING_WENT_WRONG");
    } on Exception catch (e) {
      throw Exception("INTERNAL ERROR : ${e.toString()}");
    }
  }

  Future<User> updateUserProfile(
    String name,
    String email,
    String avatar,
    String bio,
    Map<String, String> socialLinks,
  ) async {
    final token = await _getToken();

    try {
      final response = await http.put(
        Uri.parse("$baseURL/api/users/profile"),
        headers: {"x-auth-token": token},
        body: jsonEncode({
          "name": name,
          "email": email,
          "avatar": avatar,
          "bio": bio,
          "socialLinks": socialLinks,
        }),
      );

      _handleTokenError(response);

      if (response.statusCode == 200) {
        final dynamic userDetails = jsonDecode(response.body);
        User user = userDetails['user'].map((e) => User.fromJson(e));
        print("User Profile Update Successful");
        return user;
      }

      if (response.statusCode == 401) {
        print("User Profile Update Error: ${response.body}");
        return Future.error("AUTH_EXPIRED");
      }

      print("SOMETHING WENT WRONG WHILE UPDATE USER PROFILE!!!");
      return Future.error("SOMETHING_WENT_WRONG");
    } on Exception catch (e) {
      throw Exception("INTERNAL ERROR : ${e.toString()}");
    }
  }

  void _handleTokenError(http.Response response) async {
    if (response.statusCode == 401 ||
        response.body.contains("invalid") ||
        response.body.contains("expired")) {
      await LocalStorage().delete("token");
      throw Exception("AUTH_EXPIRED");
    }
    return;
  }

  Future<String> _getToken() async {
    return await LocalStorage().get("token") ?? "";
  }
}
