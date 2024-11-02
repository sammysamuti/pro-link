import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/firebase/firebase.dart';
import 'package:skillswap/homepageCandidate/Search/persondetail.dart';
import 'package:skillswap/homepageCandidate/Search/projectdetailtojoin.dart';
import 'package:skillswap/Request/requestpage.dart';
import 'package:skillswap/widgets/buttons.dart';

class ProjectSearch extends StatelessWidget {
  Map<String, dynamic> projectdata;
  String projectid;
  ProjectSearch(this.projectdata, this.projectid, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final UserController userController = Get.find();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProjectDetailJoin(
                        projectdata: projectdata,
                        projectid: projectid,
                      )));
        },
        child: Container(
            width: width,
            height: height * 0.45,
            decoration: BoxDecoration(),
            child: Stack(children: [
              Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: projectdata['Projectimg'],
                    imageBuilder: (context, imageProvider) => Container(
                      height: height * 0.28,
                      width: width,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                '${projectdata['ProjectTitle']}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              SizedBox(
                                height: 32,
                                child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(projectdata['userid'])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
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
                                          snapshot.data!.data()!
                                              as Map<String, dynamic>;
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PersonalDetail(
                                                          userdata, projectdata['userid'])));
                                        },
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: userdata['profilePic'],
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 30.0,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              // placeholder: (context, url) =>
                                              //     CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${userdata['First']} ${userdata['Last']}',
                                              //  "Alice Bob",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              // Row(
                              //   children: [
                              //     CachedNetworkImage(
                              //       imageUrl: projectdata['Owner']
                              //           ['profilePic'],
                              //       imageBuilder: (context, imageProvider) =>
                              //           Container(
                              //         width: 30.0,
                              //         height: 30.0,
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           image: DecorationImage(
                              //               image: imageProvider,
                              //               fit: BoxFit.cover),
                              //         ),
                              //       ),
                              //       // placeholder: (context, url) =>
                              //       //     CircularProgressIndicator(),
                              //       errorWidget: (context, url, error) =>
                              //           Icon(Icons.error),
                              //     ),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     Text(
                              //       '${projectdata['Owner']['First']} ${projectdata['Owner']['Last']}',
                              //       //  "Alice Bob",
                              //       style: TextStyle(
                              //         color: Colors.black,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Text(
                                '${projectdata['ProjectDes']}',
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        ButtonTwo("Join", Colors.white, Color(0XFF2E307A),
                            width * 0.08, height * 0.05, 12, () {
                          // _showBottomSheet(context,projectdata['SkillReq']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RequestPage(projectdata, projectid)));
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ])),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, List<dynamic> skills) {
    List<String> selectedSkills = [];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController message = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomTextFormField(
                      width: width * 0.9,
                      height: height * 0.06,
                      hintText: "Message",
                      controller: message),
                  Text(
                    'Apply for',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        final item = skills[index];
                        return CheckboxListTile(
                          title: Text(item),
                          value: selectedSkills.contains(item),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedSkills.add(item);
                              } else {
                                selectedSkills.remove(item);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonTwo("Send", Colors.white, Color(0XFF2E307A),
                        width * 0.45, height * 0.07, 10, () {
                      Navigator.pop(context);
                    }),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
