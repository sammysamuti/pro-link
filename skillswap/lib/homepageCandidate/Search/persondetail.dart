import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Front/signin.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/Message/chatDetailPage.dart';
import 'package:skillswap/Request/completedProjects.dart';
import 'package:skillswap/Request/workingonprodetail.dart';
// import 'package:skillswap/homepageCandidate/homepage.dart';
import 'package:skillswap/homepageCandidate/newskill.dart';
import 'package:skillswap/widgets/skillimg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skillswap/firebase/firebase.dart';

class PersonalDetail extends StatelessWidget {
  Map<String, dynamic> userdata;
  String userid;

  PersonalDetail(this.userdata, this.userid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
         final FirebaseAuth _authentication = FirebaseAuth.instance;

Future<String?> fetchOrCreateChatRoomId(String uid1, String uid2) async {
    List<String> participantUids = [uid1, uid2];
    participantUids.sort(); // Ensure consistent order of participants

    DocumentReference chatRoomRef = FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc('${participantUids[0]}_${participantUids[1]}');

    DocumentSnapshot snapshot = await chatRoomRef.get();

    if (snapshot.exists) {
      return chatRoomRef.id;
    } else {
      try {
        await chatRoomRef.set({
          'participants': participantUids,
          // Add any other fields you want to initialize for the chat room
        });
        return chatRoomRef.id;
      } catch (e) {
        print('Error creating chat room: $e');
        return null;
      }
    }
  }


 Future<Widget> completedProject(String projectid, int rate) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('CompletedProjects')
      .doc(projectid)
      .get();
  Map<String, dynamic> projectdata =
      snapshot.data() as Map<String, dynamic>;
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompletedProDetail(projectdata)));},
    child: Container(
      width: width * 0.4,
      height: height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: projectdata['Projectimg'],
            imageBuilder: (context, imageProvider) => Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(
            projectdata['ProjectTitle'],
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 8),
          rate != 6?Row(
            children: List.generate(5, (index) {
              if (index < rate) {
                // Render golden star
                return Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                );
              } else {
                // Render empty star
                return Icon(
                  Icons.star_border,
                  color: Colors.grey,
                  size: 24,
                );
              }
            }),
          ):Text("Owner")
    
        ],
      ),
    ),
  );
}
    
    Future workingonProject(String projectid) async {
      ProjectController projectController = Get.find();
      Map<String, dynamic> projectdata =
          await projectController.ProjectData(projectid);
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;
      return InkWell(
        onTap:  () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkingOnProDetail(projectdata)));},
        child: Container(
          width: width * 0.4,
          height: height * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: projectdata['Projectimg'],
                imageBuilder: (context, imageProvider) => Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(
                projectdata['ProjectTitle'],
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: userdata['profilePic'],
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Icon(Icons.person),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(
                    width: width * 0.08,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userdata['First']} ${userdata['Last']}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      GestureDetector(
                        onTap: () => _launchInEmailApp(userdata['Email']),
                        child: Row(
                          children: [
                            Image.asset(
                              logomap['email']!,
                              width: width * 0.1,
                              height: height * 0.02,
                            ),
                            SizedBox(
                              width: width*0.4,
                              child: Text(
                                userdata['Email'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: height*0.03,),
                Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 20,
                  child: Expanded(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }

                        Map<String, dynamic> data =
                            snapshot.data!.data()! as Map<String, dynamic>;
                        var stars = data['Star'] as List<dynamic>?;
                        print(stars);
                        // Calculate average of stars
                        double averageStar = stars != null && stars.isNotEmpty
                            ? stars.reduce((a, b) => a + b) / stars.length
                            : 0;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemExtent: 20,
                          itemBuilder: (context, index) {
                            if (index < averageStar.floor()) {
                              // If index is less than the floor of averageStar, paint the star golden
                              return Icon(Icons.star, color: Colors.amber);
                            } else {
                              // Otherwise, paint the star grey
                              return Icon(Icons.star_border,
                                  color: Colors.grey);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Container(
                padding: const EdgeInsets.all(10),
                width: width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Skills",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Expanded(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: RawScrollbar(
                                thumbVisibility: true,
                                thumbColor: Color(0XFF2E307A),
                                radius: Radius.circular(20),
                                thickness: 5,
                                child: Wrap(
                                  spacing:
                                      8, // Adjust the spacing between items as needed
                                  runSpacing:
                                      8, // Adjust the spacing between lines as needed
                                  children: List.generate(
                                      userdata['Skills'] != null
                                          ? userdata['Skills'].length
                                          : 0, (index) {
                                    Map<String, dynamic> skill =
                                        userdata['Skills'][index];

                                    if (logomap.containsKey(skill['skill'])) {
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(skill['skill']),
                                                      Text(skill['level'])
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Image.asset(
                                          logomap[skill['skill']]!,
                                          width: width * 0.2,
                                          height: height * 0.05,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(skill['skill']),
                                                      Text(skill['level'])
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color.fromARGB(
                                              255, 237, 241, 245),
                                          radius: 30,
                                          child: Text(
                                            skill['skill'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 237, 241, 245),
                ),
                constraints: const BoxConstraints(
                  minHeight: 100.0,
                ),
                width: width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bio",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(userdata['Bio']),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              InkWell(
                onTap: () async {
                      String? chatRoomId =
                          await fetchOrCreateChatRoomId(userid,  _authentication.currentUser!.uid);
                      if (chatRoomId != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(
                              currentUserUid:  _authentication.currentUser!.uid,
                              chatRoomId: chatRoomId,
                              recipientUid: userid,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error creating or fetching chat room!'),
                          ),
                        );
                      }
                    },
                child: Row(
                  children: [
                         Image.asset(width: width * 0.12, height: height * 0.04, "asset/send.png"),
                        Text("Contact"),
                  ],
                ),
              ),
              userdata['Linkedin'] != null && userdata['Linkedin'] != ''
                  ? Row(
                      children: [
                        Image.asset(
                          logomap['linkedin']!,
                          width: width * 0.12,
                          height: height * 0.04,
                        ),
                        InkWell(
                          onTap: () => _launchInBrowser(
                              'https://linkedin.com/in/', userdata['Linkedin']),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10),
                            //  color: Color.fromARGB(255, 237, 241, 245),
                            // ),
                            width: width * 0.76,
                            child: Text(userdata['Linkedin']),
                          ),
                        )
                      ],
                    )
                  : Container(),

              SizedBox(height: height * 0.03),
              userdata['Github'] != null && userdata['Github'] != ''
                  ? Row(
                      children: [
                        Image.asset(
                          logomap['github']!,
                          width: width * 0.12,
                          height: height * 0.04,
                        ),
                        InkWell(
                          onTap: () => _launchInBrowser(
                              'https://github.com/', userdata['Github']),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10),
                            //  color: Color.fromARGB(255, 237, 241, 245),
                            // ),
                            width: width * 0.76,
                            child: Text(userdata['Github']),
                          ),
                        )
                      ],
                    )
                  : Container(),
              SizedBox(
                height: height * 0.02,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Working On Projects",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              
              RawScrollbar(
                thumbVisibility: true,
                thickness: 5,
                thumbColor: Color(0XFF2E307A),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    Map<String, dynamic> data =
                        snapshot.data!.data()! as Map<String, dynamic>;
                    var projects = data['WorkingOnPro'] as List<dynamic>?;

                    if (projects == null || projects.isEmpty) {
                      return const Text('No projects available');
                    }

                    return SizedBox(
                      height: height*0.2,
                      child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            future: workingonProject(
                                        data['WorkingOnPro'][index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(); // Or any loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return snapshot.data!;
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
             
              SizedBox(
                height: height * 0.02,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Personal Projects",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
             RawScrollbar(
                thumbVisibility: true,
                thickness: 5,
                thumbColor: Color(0XFF2E307A),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    Map<String, dynamic> data =
                        snapshot.data!.data()! as Map<String, dynamic>;
                    var projects = data['MyProjects'] as List<dynamic>?;

                    if (projects == null || projects.isEmpty) {
                      return const Text('No projects available');
                    }

                    return SizedBox(
                      height: height*0.2,
                      child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            future: workingonProject(
                                        data['MyProjects'][index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(); // Or any loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return snapshot.data!;
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Completed Projects",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
            RawScrollbar(
              thumbVisibility: true,
                thickness: 5,
                thumbColor: Color(0XFF2E307A),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                
                    Map<String, dynamic> data =
                        snapshot.data!.data()! as Map<String, dynamic>;
                    var projects = data['CompletedProject'] as List<dynamic>?;
                
                    if (projects == null || projects.isEmpty) {
                      return const Text('No projects available');
                    }
                
                    return SizedBox(
                      height: height*0.2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            future:
                                completedProject(projects[index]['projectId'],projects[index]['rate']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(); // Or any loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return snapshot.data!;
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String app, String url) async {
    final Uri toLaunch = Uri.parse('$app$url');
    if (!await launchUrl(
      toLaunch,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchInEmailApp(String email) async {
    final Uri toLaunch = Uri.parse('mailto:$email');
    if (!await launchUrl(
      toLaunch,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch email to $email');
    }
  }
}
