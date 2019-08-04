import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serictest/model/home/home.dart';
import 'package:serictest/server/general.dart';

///user related information to be fetched from, server
class UserServer {
  /// list of user to be display at home screen
  /// params: page > which page data to be fetched
  /// return:
  ///     success: Home instance
  ///     error: exception or internet error
  Future getUserList(int page) async {
    http.Response response;
    try {
      bool success = false;
      var responseData;

      bool checkInternet = await General().checkInternet();
      if (checkInternet) {
        response = await http.get(
          "https://reqres.in/api/users?page=$page",
        );
        var decode = json.decode(response.body);

        if (response.statusCode == 400) {
          success = false;
          responseData = decode['error'];
        } else if (response.statusCode == 200) {
          success = true;
          responseData = Home.fromJson(decode);
        }
        return {'success': success, 'response': responseData};
      } else {
        return {'success': false, 'response': "No Internet Connection"};
      }
    } catch (e) {
      print("Error user getlist");
      print(e.toString());
      return {'success': false, 'response': "Error"};
    }
  }
}
