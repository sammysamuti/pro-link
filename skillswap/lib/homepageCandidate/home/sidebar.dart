import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Front/recruiterORuser.dart';
import 'package:skillswap/Front/signin.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/Message/chatRoomTab.dart';
import 'package:skillswap/Message/message.dart';
// import 'package:skillswap/pages/contact.dart';
import 'package:skillswap/pages/setting.dart';

class SideBar extends StatelessWidget {
  SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ProjectController projectController = Get.put(ProjectController());
    final UserController userController = Get.find();
    final FirebaseAuth _authentication = FirebaseAuth.instance;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(_authentication.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          Map<String, dynamic> userdata =
              snapshot.data!.data()! as Map<String, dynamic>;
          var projects = userdata['WorkingOnPro'] as List<dynamic>?;
          var completedProjects =
              userdata['CompletedProject'] as List<dynamic>?;
          var stars = userdata['Star'] as List<dynamic>?;
          double averageStar = stars != null && stars.isNotEmpty
              ? stars.reduce((a, b) => a + b) / stars.length
              : 0;

          return Drawer(
            backgroundColor: Color.fromARGB(255, 237, 241, 245),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color(0XFF2E307A),
                        ),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: userdata['profilePic'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Text(
                              '${userdata['First']} ${userdata['Last']} ',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.house,
                          size: 30,
                        ),
                        title: Text('Home'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.phone,
                          size: 30,
                        ),
                        title: Text('Contact'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  MessagePage(currentUserUid: _authentication.currentUser!.uid),));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.gear,
                          size: 30,
                        ),
                        title: Text('Settings'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ),
                          );
                        },
                      ),
                      
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Color(0XFF2E307A),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Color(0XFF2E307A)),
                  ),
                  onTap: () {
                    projectController.clearProjects();
                    userController.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
