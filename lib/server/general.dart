import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///Data that remain constant to remove replication
class General {
  ///checks internet connection
  ///Duration 5 seconds
  ///response:
  ///   Success> true
  ///   else > flase
  Future<bool> checkInternet() async {
    try {
      final result1 = await http
          .read('https://jsonplaceholder.typicode.com/todos/1')
          .timeout(const Duration(seconds: 5));

      return true;
    } catch (e) {
      return false;
    }
  }

  ///Snackbar to internet connection error
  ///remove snackbar when action is pressed
  ///Duration 3600 seconds
  ///params:
  ///   scaffoldKey > key of current scaffold
  ///   fun > Function to execute when user click retry
  snackBarInternet(scaffoldKey, fun) {
    try {
      scaffoldKey.currentState
          .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
    } catch (e) {
      print(e);
    }

    scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.red.withOpacity(0.8),
      duration: Duration(seconds: 3600),
      action: SnackBarAction(
        label: "Retry",
        textColor: Colors.white,
        onPressed: fun,
      ),
      content: new Text(
        "No Internet Connection",
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  ///simple snackbar to show error
  ///remove snackbar when action is pressed
  ///params:
  ///   scaffoldKey > key of current scaffold
  ///   message > message to be show to user
  snackBar(scaffoldKey, message) {
    print("Snackbar");
    try {
      scaffoldKey.currentState
          .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
    } catch (e) {
      print(e);
    }
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.red.withOpacity(0.8),
      duration: Duration(seconds: 3),
      content: new Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
