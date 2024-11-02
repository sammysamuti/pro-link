import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/completeProject.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/projectedit.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/teamsprofile.dart';
import 'package:skillswap/widgets/buttons.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectid;
  const ProjectDetailPage({super.key, required this.projectid});

  @override
  Widget build(BuildContext context) {
    // Fetch project details based on the profileId here
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserController userController = UserController();

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Project')
            .doc(projectid)
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

          Map<String, dynamic> projectdata =
              snapshot.data!.data()! as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text('${projectdata['ProjectTitle']}'),
              centerTitle: true,
              backgroundColor: Colors.white,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProjectEdit(projectid: projectid,)));
                    } 
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    
                    // Add more PopupMenuItems as needed
                  ],
                  icon: Icon(CupertinoIcons.ellipsis_vertical),
                  color: Colors.white,
                  offset: Offset(0, 40),
                ),
              ],
            ),
            body: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: projectdata['Projectimg'],
                        imageBuilder: (context, imageProvider) => Container(
                          height: height * 0.4,
                          width: width,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      const SizedBox(height: 40),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 80,
                                  height: 2,
                                  //  color: Colors.black,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${projectdata['ProjectTitle']}",
                                  style: TextStyle(fontSize: 30),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${projectdata['TimeStamp']}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${projectdata['ProjectDes']}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 80,
                                        height: 2,
                                        //  color: Colors.black,
                                      ),
                                      const SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "Required Skills",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ListView.builder(
                                              itemCount: projectdata['SkillReq']
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return Text(
                                                    '${projectdata['SkillReq'][index]}');
                                              })),
                                    ],
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "Teams",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                projectdata['Teams'].length == 0
                                    ? Text("No Teams")
                                    : RawScrollbar(
                                        thickness: 20.0,
                                        thumbVisibility: true,
                                        thumbColor: Color(0XFF2E307A),
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            height: 400,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ListView.builder(
                                                itemCount:
                                                    projectdata['Teams'].length,
                                                itemBuilder: (context, index) {
                                                  return StreamBuilder<
                                                      DocumentSnapshot>(
                                                    stream: userController
                                                        .getuserdata(
                                                            projectdata['Teams']
                                                                [index]),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator(); // Show a loading indicator while fetching data
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}'); // Show an error message if something goes wrong
                                                      } else {
                                                        if (snapshot.hasData &&
                                                            snapshot
                                                                .data!.exists) {
                                                          // Document exists, use its data

                                                          var userData =
                                                              snapshot.data!
                                                                  .data();
                                                          return TeamsProfile(
                                                              userData as Map<
                                                                  String,
                                                                  dynamic>,
                                                              projectdata[
                                                                      'Teams']
                                                                  [index]);
                                                        } else {
                                                          // Document doesn't exist
                                                          return Text(
                                                              'User data not found');
                                                        }
                                                      }
                                                    },
                                                  );
                                                })),
                                      ),
                              ])),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Center(
                        child: ButtonTwo(
                            "Complete",
                            Colors.white,
                            Color(0XFF2E307A),
                            width * 0.7,
                            height * 0.07,
                            20, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompleteProject(
                                      projectdata['ProjectTitle'],
                                      projectdata['Teams'],
                                      projectid)));
                        }),
                      ),
                    ])),
          );
        });
  }
}
