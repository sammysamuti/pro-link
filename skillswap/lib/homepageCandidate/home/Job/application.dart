import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/Request/requestTemplate.dart';
import 'package:skillswap/Request/sendrequest.dart';
import 'package:skillswap/homepageCandidate/home/homepage.dart';
import 'package:skillswap/widgets/buttons.dart';
import 'package:file_picker/file_picker.dart';

class JobApplication extends StatefulWidget {
  Map<String, dynamic> jobdata;

  JobApplication(this.jobdata, {super.key});
  // JobApplication({super.key});

  @override
  State<JobApplication> createState() => _JobApplicationState();
}

class _JobApplicationState extends State<JobApplication> {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final UserController userController = Get.find();
  RequestSend request = RequestSend();
  void Apply(String recieverid, String message, String projectid,String title,
     ) async {
    await request.sendApplication(recieverid, projectid, message,userController.userdata,title);
  }
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final String senderid = _authentication.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.arrow_left, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Job'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
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
            const FormText(
                text: "Why do you want to apply?",
                alignment: Alignment.centerLeft),
            CustomTextFormFieldTwo(
              width: width * 0.9,
              height: height * 0.06,
              hintText: "Message",
              controller: message,
              maxLine: null,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: ButtonTwo("Send", Colors.white, Color(0XFF2E307A),
                  width * 0.45, height * 0.05, 17, () {
                    if(!message.text.isEmpty)
                {
                
                  Apply(widget.jobdata['userId'],message.text,widget.jobdata['JOB'],widget.jobdata['title']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Application sent!'),
                    duration:
                        Duration(seconds: 2), // Adjust the duration as needed
                  ),
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage(senderid)),
                  (route) => false,
                );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill the Application Form!'),
                    duration:
                        Duration(seconds: 2), // Adjust the duration as needed
                  ),
                );

                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
