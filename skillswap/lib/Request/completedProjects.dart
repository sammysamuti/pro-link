import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/teamsprofile.dart';
import 'package:url_launcher/url_launcher.dart';


class CompletedProDetail extends StatelessWidget {
  final Map<String, dynamic> detail;
  const CompletedProDetail(this.detail,{super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final UserController userController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('${detail['ProjectTitle']}'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CachedNetworkImage(
              imageUrl: detail['Projectimg'],
              imageBuilder: (context, imageProvider) => Container(
                height: height * 0.4,
                width: width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
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
                        "${detail['ProjectTitle']}",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${detail['TimeStamp']}',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${detail['ProjectDes']}',
                        style: TextStyle(fontSize: 15),
                      ),
                      detail.containsKey('Url')?InkWell(
                          onTap: () => _launchInBrowser(
                              detail['Url']),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10),
                            //  color: Color.fromARGB(255, 237, 241, 245),
                            // ),
                            width: width * 0.76,
                            child: Text("Click here to discover more about the Project",style: TextStyle(color: Colors.blue,fontSize: 15, decoration: TextDecoration.underline,),),
                          ),
                        ):Container(),

                      
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListView.builder(
                                    itemCount:
                                        detail['SkillReq'].length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                          '${detail['SkillReq'][index]}');
                                    })),

                          ],
                        ),
                      ),

                       Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Teams",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                      detail['Teams'].length == 0?Text("No Teams"): RawScrollbar(
                        thickness: 20.0,
                        thumbVisibility: true,
                        thumbColor: Color(0XFF2E307A),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:    
                         ListView.builder(
                                itemCount: detail['Teams'].length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: userController.getuserdata(
                                        detail['Teams'][index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Show a loading indicator while fetching data
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error: ${snapshot.error}'); // Show an error message if something goes wrong
                                      } else {
                                        if (snapshot.hasData &&
                                            snapshot.data!.exists) {
                                          // Document exists, use its data

                                          var userData = snapshot.data!.data();
                                          return TeamsProfile(
                                              userData as Map<String, dynamic>,
                                              detail['Teams'][index]);
                                        } else {
                                          // Document doesn't exist
                                          return Text('User data not found');
                                        }
                                      }
                                    },
                                  );
                                })),
                      ),
                    ]))
          ])),
    );
  }
  Future<void> _launchInBrowser(String url) async {
    final Uri toLaunch = Uri.parse('$url');
    if (!await launchUrl(
      toLaunch,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
