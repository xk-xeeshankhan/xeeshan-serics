import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

///user model
@JsonSerializable(nullable: true)
class User {
  int id;
  String email;
  String first_name;
  String last_name;
  String avatar;

  User(this.id, this.email, this.first_name, this.last_name, this.avatar);

  factory User.fromJson(Map<String, dynamic> json) => UserFromJson(json);
}
