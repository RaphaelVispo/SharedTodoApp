import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:intl/intl.dart';


class viewFriendProfile extends StatelessWidget {
  final UserModel friend;
  const viewFriendProfile({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Padding(
                    padding: EdgeInsets.only(top: 70, left: 30, right: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Profile",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Id: ${friend.id} ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Name: ${friend.firstName} ${friend.lastName}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Birthday: ${DateFormat().add_yMMMd().format(friend.birthday!)} ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Location: ${friend.location?['longitude']} ${friend.location?['latitude']} ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20),
                          ),
                        ),
                        
                     
                      ],
                    ),
                  )]
                ))
          
        );

  }
}