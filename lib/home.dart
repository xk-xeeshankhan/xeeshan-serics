import 'package:flutter/material.dart';
import 'package:serictest/mydrawer.dart';
import 'package:serictest/server/general.dart';
import 'package:serictest/userdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'model/home/home.dart';
import 'server/user.dart';

///Shows the list of the user fetched from the api
///Pagination
///user info with first and last name and profile pic
///on click redirect to specific user detail
class HomePge extends StatefulWidget {
  @override
  _HomePgeState createState() => _HomePgeState();
}

class _HomePgeState extends State<HomePge> {
  ///Instances
  Home homeData;

  ///current user email
  String email = '';

  ///progress of data from server
  bool progress = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserEmail();
    getDataFromServer(1);
  }

  ///get login user email
  ///hide the user from the list of fetched user
  getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  ///fetched list of user from api
  ///Success: display list
  ///Error: snackbar
  getDataFromServer(int index) async {
    await UserServer().getUserList(index).then((res) {
      if (res['success']) {
        homeData = res['response'];
        print("home");
        print(homeData);
        setState(() {
          progress = false;
        });
      } else {
        if (res['response'] == "No Internet Connection") {
          General().snackBarInternet(_scaffoldKey, () {
            getDataFromServer(index);
          });
        } else {
          General().snackBar(_scaffoldKey, res['response']);
        }
      }
    });
  }

  /// app bar with center align
  ///show progress indicator until data is loaded from server
  /// drawer towards left
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "User List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(40, 8, 105, 1.0),
        centerTitle: true,
      ),
      body: progress
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ))
          : ListView.builder(
              itemCount: homeData.userList.length + 1,
              itemBuilder: (context, index) {
                if (index == homeData.userList.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _showPage()),
                  );
                } else {
                  return _userInfo(index);
                }
              }),
      drawer: MyDrawer(),
    );
  }

  ///a specific user detail to be show on screen
  ///contain : image+ first and last name and email address
  ///if current user email match show nothing
  ///params:
  ///   index> user data at specific index fetched from server
  _userInfo(index) {
    if (homeData.userList[index].email == email) {
      return Container();
    }
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserDetail(user: homeData.userList[index])));
      },
      leading: Container(
        width: 50.0,
        height: 50.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200.0),
          child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(homeData.userList[index].avatar),
              fit: BoxFit.fill),
        ),
      ),
      title: Text(
        homeData.userList[index].first_name +
            " " +
            homeData.userList[index].last_name,
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      subtitle: Text(
        homeData.userList[index].email,
        style: TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
    );
  }

  ///check the number of total pages
  ///create loop to show each page index and add it to the list
  ///return list of numbers for pagination
  _showPage() {
    List<Widget> widget = [];
    for (int i = 1; i <= homeData.total_pages; i++) {
      widget.add(_pageNumber(i));
    }
    return widget;
  }

  ///create page number ui for pagination
  ///onclick fetch data for the clicked page
  ///will not execute if both the click and current show page match
  _pageNumber(int index) {
    return InkWell(
      onTap: () {
        if (index != homeData.page) getDataFromServer(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          index.toString(),
          style: TextStyle(
              fontSize: 16.0,
              color: index != homeData.page ? Colors.grey : Colors.purple),
        ),
      ),
    );
  }
}
