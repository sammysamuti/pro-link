import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/completeProject.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/editor.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/projectedit.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/teamsprofile.dart';
import 'package:skillswap/widgets/buttons.dart';

class ProjectEdit extends StatelessWidget {
  final String projectid;
  const ProjectEdit({super.key, required this.projectid});

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
                    
                    } else if (value == 'Delete') {}
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${projectdata['ProjectTitle']}",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    TitleEdit(projectdata['ProjectTitle'],projectid),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${projectdata['TimeStamp']}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child:  DescriptionEdit(projectdata['ProjectDes'], projectid),),
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
                                      Row(
                                        children: [
                                          Text(
                                            "Required Skills",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          AddSkill(projectid),
                                        ],
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
                               
                               
                              ])),
                      SizedBox(
                        height: height * 0.03,
                      ),
                    ])),
          );
        });
  }
}
