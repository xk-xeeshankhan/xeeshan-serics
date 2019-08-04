import 'package:flutter/material.dart';
import 'package:serictest/home.dart';
import 'package:serictest/server/account.dart';
import 'package:serictest/server/general.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn_Up extends StatefulWidget {
  SignIn_Up({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignIn_UpState createState() => _SignIn_UpState();
}

class _SignIn_UpState extends State<SignIn_Up> {

  ///Controller for email/username and password
  TextEditingController _userNameController;
  TextEditingController _passwordController;

  ///focus node, active when user click submit button of email field
  FocusNode _passwordFocus;

  ///global scaffold of current page
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ///check to see which ui to be show
  bool isLoginUI = true;

  ///when data is send to server show progress using the below variable
  bool sendDataToServerProgress = false;

  ///form key for form validation
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordFocus = FocusNode();
  }

  ///used stack to show the background image and content on top of it
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _backgroundImage(),
//        Positioned(
//            top: MediaQuery.of(context).size.height * .1,
//            child: Container(
//              width: MediaQuery.of(context).size.width,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//
//                ],
//              ),
//            )),
            _form(),
          ],
        ));
  }

  ///background image
  ///user fade image transition for good look
  _backgroundImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage('assets/images/image2.jpg'),
          fit: BoxFit.cover),
    );
  }

  ///form that is used to send data to server
  ///verify email before sending it to server
  ///reset state when changing from login to signup and vice versa
  _form() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text("SERICS",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            _emailTextField(),
            SizedBox(
              height: 15.0,
            ),
            _passwordTextField(),
            SizedBox(height: 25.0),
            InkWell(
              onTap: () {
                _formKey.currentState.reset();
                setState(() {
                  isLoginUI = !isLoginUI;
                });
              },
              child: Text(
                  isLoginUI ? "Register New Account" : "Have Account? Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            _customSubmitButton(),
          ],
        ),
      ),
    );
  }

  ///the ui widget for email
  _emailTextField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        controller: _userNameController,
        validator: (val) {
          return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
              ? null
              : "Invalid Email";
        },
        keyboardType: TextInputType.emailAddress,
        onFieldSubmitted: (val) {
          FocusScope.of(context).requestFocus(_passwordFocus);
        },
//                      autofocus: true,
        decoration: InputDecoration(
          hintText: "example@domain.com",
          labelStyle: TextStyle(color: Colors.grey),
          labelText: "Email Address",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.email, color: Colors.grey),
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
          fillColor: Colors.white,
        ),
      ),
    );
  }

  ///the ui widget for password, with obsure text true
  _passwordTextField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        focusNode: _passwordFocus,
//        validator: (val){
//          return val.length>0?null:"Provide Password";
//        },
        onFieldSubmitted: (val) {
          try{
            FocusScope.of(context).requestFocus(new FocusNode());

          }catch(e){}
          _validateData();
        },
//                      autofocus: true,
        decoration: InputDecoration(
          hintText: "******",
          labelStyle: TextStyle(color: Colors.grey),
          labelText: "Password",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
          fillColor: Colors.white,
        ),
      ),
    );
  }

  ///validate the form data before calling server
  _validateData(){
    if (_formKey.currentState.validate()) {
      ///in case of all field are valid

      _sendDataToServer();
    } else {
      print("test 2");
    }
  }

  ///the ui widget for the button
  _customSubmitButton() {
    return sendDataToServerProgress
        ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
        ))
        : InkWell(
      onTap: () {
        _validateData();
//        Navigator.of(context).pushReplacement(
//            MaterialPageRoute(builder: (context) => Home()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .1),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(40, 8, 105, 1.0),
              Color.fromRGBO(162, 129, 230, 1.0),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        child: Text(isLoginUI ? "Sign In" : "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20.0)),
      ),
    );
  }

  ///send data to server depending upon current the ui
  ///login ui> called _loginUser
  ///signup ui> called sigupUser
  _sendDataToServer() {
    print(_userNameController.text);
    print(_passwordController.text);
    try {
      _scaffoldKey.currentState.removeCurrentSnackBar();
    } catch (e) {}

    setState(() {
      sendDataToServerProgress = true;
    });
    if (isLoginUI) {
      _loginUser();
    } else {
      _signUpUser();
    }
  }

  ///make a server call with provided credentails
  ///show snackbar in case of error
  ///in case of success:
  ///   create session with SharedPreferences so user will remain login
  ///   and navigate to home screen
  ///SharedPrefs stores> token and email
  _loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Account()
          .loginUser(_userNameController.text.toString(),
          _passwordController.text.toString())
          .then((response) {
        print(response['success']);
        print(response['response']);
        if (response['success']) {
          ///navigate and create sharedprefs
          prefs.setString('token', response['response']);
          prefs.setString('email', _userNameController.text.toString());
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => HomePge()));
        } else {
          ///show error
          if (response['response'] == "No Internet Connection") {
            General().snackBarInternet(_scaffoldKey, () {
              _loginUser();
            });
          } else {
            General().snackBar(_scaffoldKey,response['response']);
          }
          setState(() {
            sendDataToServerProgress = false;
          });
        }
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        sendDataToServerProgress = false;
      });
    }
  }


  ///make a server call with provided credentails
  ///show snackbar in case of error
  ///in case of success:
  ///   create session with SharedPreferences so user will remain login
  ///   and navigate to home screen
  ///SharedPrefs stores> token and email
  _signUpUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Account()
          .signupUser(_userNameController.text.toString(),
          _passwordController.text.toString())
          .then((response) {
        print(response['success']);
        print(response['response']);
        if (response['success']) {
          ///navigate and create sharedprefs
          int id = response['response']['id'];
          String token = response['response']['token'];
          print(id);
          print(token);

          prefs.setString('token', response['response']['token']);
          prefs.setString('email', _userNameController.text.toString());

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => HomePge()));
        } else {
          ///show error
          if (response['response'] == "No Internet Connection") {
            General().snackBarInternet(_scaffoldKey, () {
              _signUpUser();
            });
          } else {
            General().snackBar(_scaffoldKey,response['response']);
          }
          setState(() {
            sendDataToServerProgress = false;
          });
        }
      });
    } catch (e) {
      print("Error Sign Up");
      print(e.toString());
      setState(() {
        sendDataToServerProgress = false;
      });
    }
  }

}