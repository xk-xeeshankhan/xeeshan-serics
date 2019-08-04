import 'package:flutter/material.dart';
import 'package:serictest/main.dart';
import 'package:serictest/signin_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {

  ///left drawer shown at home page
  ///List contain:
  ///   1. Logout
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(40, 8, 105, 1.0),
              Color.fromRGBO(162, 129, 230, 1.0),
            ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,)
        ),
        child: Column(

          children: <Widget>[

            SizedBox(height:MediaQuery.of(context).size.height*0.1),

            Text("SERICS",style: TextStyle(color:Colors.white,fontSize: 30.0,fontWeight: FontWeight.bold),),

            SizedBox(height:MediaQuery.of(context).size.height*0.35),
            ///Logout current user and redirect to signin page
            ///Delete the session from SharedPreferences
            Center(
              child: ListTile(
                onTap: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignIn_Up()));
                },
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white,fontSize: 18.0),
                ),
                leading: Icon(Icons.exit_to_app,color: Colors.white,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
