part of 'user.dart';

User UserFromJson(Map<String, dynamic> json) {
  return User(
      json['id'] != null ? json['id'] as int : 0,
      json['email'] != null ? json['email'] as String : "",
      json['first_name'] != null ? json['first_name'] as String : "",
      json['last_name'] != null ? json['last_name'] as String : "",
      json['avatar'] != null ? json['avatar'] as String : "");
}
