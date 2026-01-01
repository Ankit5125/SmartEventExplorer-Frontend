class User {
  final String token;
  final String name;
  final String email;
  final String role;
  final String organizerStatus;
  final String avatar;
  final String bio;
  final String id;

  final Map<String, String> socialLinks;

  User({
    required this.token,
    required this.name,
    required this.email,
    required this.role,
    required this.organizerStatus,
    required this.avatar,
    required this.bio,
    required this.socialLinks,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data;
    if (json.containsKey('user') && json['user'] != null) {
      data = json['user'];
    } else {
      data = json;
    }

    return User(
      token: (json['token'] ?? "").toString(),

      id: (data['_id'] ?? "").toString(),
      name: (data['name'] ?? "Unknown").toString(),
      email: (data['email'] ?? "No Email").toString(),
      role: (data['role'] ?? "user").toString(),
      organizerStatus: (data['organizerStatus'] ?? "none").toString(),
      avatar: (data['avatar'] ?? "").toString(),
      bio: (data['bio'] ?? "").toString(),
      socialLinks: data['socialLinks'] is Map
          ? Map<String, String>.from(data['socialLinks'])
          : {},
    );
  }
}
