import 'package:flutter/material.dart';
import 'package:serictest/home.dart';
import 'package:serictest/signin_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checkHomePage = false;

  ///after 5 seconds redirect to the page as concluded by _checkHomeorLogin
  ///redirect user to home page if logged in
  ///redirect to signin if no user found
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkHomeorLogin();

    Future.delayed(Duration(seconds: 5), () {
      if (_checkHomePage) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePge()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignIn_Up()));
      }
    });
  }

  /// check if user is login or not
  _checkHomeorLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null && prefs.getString('token') != "") {
      setState(() {
        _checkHomePage = true;
      });
    } else {
      setState(() {
        _checkHomePage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _backgroundImage(),
          Container(
            width:MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height,
            color:Colors.black.withOpacity(0.4)
          ),
          _logo(),
        ],
      ),
    );
  }

  ///simple background image from assets with fade image transition
  _backgroundImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage('assets/images/image1.jpg'),
          fit: BoxFit.cover),
    );
  }

  ///logo text for ui
  _logo() {
    return Center(
        child: Text(
      "SERICS",
      style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold,color:Colors.white),
    ));
  }
}
//eve.holt@reqres.in