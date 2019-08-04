import 'package:json_annotation/json_annotation.dart';
import 'package:serictest/model/user/user.dart';

///Supporting this file by home.g.dart
part 'home.g.dart';

///Home page content model class
@JsonSerializable(nullable: true)
class Home {
  int page;
  int per_page;
  int total;
  int total_pages;
  List<User> userList;

  Home(this.page, this.per_page, this.total, this.total_pages, this.userList);

  factory Home.fromJson(Map<String, dynamic> json) => HomeFromJson(json);
}
