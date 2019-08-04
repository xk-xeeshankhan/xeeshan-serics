import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:serictest/server/general.dart';

///Communicate to server
///Login
///Signup
class Account {
  ///login user for server call
  ///email: user input
  ///password: user input
  ///Return:
  ///   -> success > token
  ///   -> error > message from server or exception or internet
  Future loginUser(String email, String password) async {
    http.Response response;
    try {
      ///checking internet is available
      bool checkInternet = await General().checkInternet();

      bool success = false;
      String responseMessage = "Error";

      if (checkInternet) {
        response = await http.post(
          "https://reqres.in/api/login",
          body: {"email": email, "password": password},
        );
        var decode = json.decode(response.body);

        if (response.statusCode == 400) {
          success = false;
          responseMessage = decode['error'];
        } else if (response.statusCode == 200) {
          success = true;
          responseMessage = decode['token'];
        }
        return {'success': success, 'response': responseMessage};
      } else {
        return {'success': false, 'response': "No Internet Connection"};
      }
    } catch (e) {
      print(e.toString());
      return {'success': false, 'response': "Error"};
    }
  }

  ///Signup user for server call
  ///email: user input
  ///password: user input
  ///Return:
  ///   -> success > token, id
  ///   -> error > message from server or exception or internet
  Future signupUser(String email, String password) async {
    http.Response response;
    try {
      bool success = false;
      var responseMessage;

      ///checking internet is available
      bool checkInternet = await General().checkInternet();
      if (checkInternet) {
        response = await http.post(
          "https://reqres.in/api/register",
          body: {"email": email, "password": password},
        );
        var decode = json.decode(response.body);

        if (response.statusCode == 400) {
          success = false;
          responseMessage = decode['error'];
        } else if (response.statusCode == 200) {
          success = true;
          responseMessage = decode;
        }
        return {'success': success, 'response': responseMessage};
      } else {
        return {'success': false, 'response': "No Internet Connection"};
      }
    } catch (e) {
      print("Error Account Sign Up");
      print(e.toString());
      return {'success': false, 'response': "Error"};
    }
  }
}
