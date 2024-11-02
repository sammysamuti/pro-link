import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/Request/completedProjects.dart';
import 'package:skillswap/Request/workingonprodetail.dart';
import 'package:skillswap/homepageRec/profileedit.dart';
import 'package:skillswap/pages/contact.dart';
import 'package:skillswap/pages/setting.dart';
import 'package:skillswap/widgets/buttons.dart';
import 'package:skillswap/widgets/skillimg.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileRec extends StatelessWidget {
  ProfileRec({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final UserController userController = Get.find();
    final FirebaseAuth _authentication = FirebaseAuth.instance;

    Future<void> pickImage() async {
      String? downloadUrl;
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // For mobile platforms, set the image directly
      final imageTemp = File(image.path);

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now()}.jpg');

      try {
        // Upload the image to Firebase Storage
        await storageReference.putFile(imageTemp!);

        // Retrieve the download URL of the uploaded image
        downloadUrl = await storageReference.getDownloadURL();
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(_authentication.currentUser!.uid);
        await docRef.update({'profilePic': downloadUrl});
        userController.userdata['profilePic'] = downloadUrl;
      } catch (e) {
        // Handle any errors that occur during the upload process
        print('Error uploading image: $e');
      }
    }


 

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Recruiter')
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
          
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(children: [
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
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Positioned(
                              top: 45,
                              right: -10,
                              child: IconButton(
                                  onPressed: pickImage,
                                  icon: Image.asset(
                                      width: 30,
                                      height: 30,
                                      "asset/camera.png")))
                        ]),
                        SizedBox(
                          width: width * 0.08,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${userdata['First']} ${userdata['Last']}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                NameEdit(userdata['First'], userdata['Last'])
                              ],
                            ),
                            SizedBox(height: 5.0),
                            GestureDetector(
                              onTap: () => _launchInEmailApp(userdata['Email']),
                              child: Text(
                                userdata['Email'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                   SizedBox(height: height * 0.03),
                  Row(
                    children: [
                     Text("Company Name",style: TextStyle(fontSize: 20),),
                      SizedBox(width: width*0.02,),
                    Text(userdata['CompanyName'])
                    ],
                  )
                   , SizedBox(height: height * 0.01),
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
                                    'https://linkedin.com/in/',
                                    userdata['Linkedin']),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10),
                                  //  color: Color.fromARGB(255, 237, 241, 245),
                                  // ),
                                  width: width * 0.6,
                                  child: Text(userdata['Linkedin']),
                                ),
                              ),
                              LinkedInEdit(userdata['Linkedin'])
                            ],
                          )
                        : Container(),
                    SizedBox(height: height * 0.03),
                     Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              NewSkill(),
                            ],
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
                                            userdata['Skills'].length, (index) {
                                          Map<String, dynamic> skill =
                                              userdata['Skills'][index];

                                          if (logomap
                                              .containsKey(skill['skill'])) {
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                skill['skill']),
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                skill['skill']),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
            ),
          );
        });
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
