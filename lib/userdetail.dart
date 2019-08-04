import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'model/user/user.dart';

class UserDetail extends StatefulWidget {
  ///receive data from the called class
  ///called by home
  User user;
  UserDetail({this.user});
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {

  ///specific user details
  ///display:
  ///   circular image of the user
  ///   first name
  ///   last name
  ///   and email address
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.first_name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(40, 8, 105, 1.0),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(40, 8, 105, 1.0),
                Color.fromRGBO(162, 129, 230, 1.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200.0),
                    child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(widget.user.avatar),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              SizedBox(height: 25.0,),
              _rowDetail("First Name",widget.user.first_name),
              _rowDetail("Last Name",widget.user.last_name),
              _rowDetail("Email Address",widget.user.email),
            ],
          ),
        ],
      ),
    );
  }

  ///show key and value pair with in equal space
  _rowDetail(title,value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 5.0),
      child: Row(children: <Widget>[
        Expanded(child: Text(title,style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),),),
        Expanded(child: Text(value,style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.w400),),)
      ],),
    );
  }
}
