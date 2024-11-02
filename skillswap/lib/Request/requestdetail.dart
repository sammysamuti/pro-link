import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Chat/chat.dart';
import 'package:skillswap/Chat/chatpage.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/Request/senderprofile.dart';
import 'package:skillswap/Request/sendrequest.dart';
import 'package:skillswap/Message/chatDetailPage.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetail extends StatelessWidget {
  Map<String, dynamic> data;
  String requestId;
  RequestDetail(this.data, this.requestId, {super.key});

  ProjectController projectController = Get.find();
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  RequestSend _request = RequestSend();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Future<String?> fetchOrCreateChatRoomId(String uid1, String uid2) async {
      String currentUid = _authentication.currentUser!.uid;
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

    void sendMessage(String message, String chatroom) async {
      if (message.isNotEmpty) {
        // Add the message to Firestore
        DocumentReference docRef = await firestore
            .collection('ChatRooms')
            .doc(chatroom)
            .collection('Messages')
            .add({
          'message': message,
          'timestamp': Timestamp.now(),
          'sender_uid': _authentication.currentUser!.uid,
          'recipient_uid': data['senderId'],
          'readBy': [
            _authentication.currentUser!.uid
          ], // Ensure readBy field is set initially
        });
      }
    }

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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SenderProfile(data['UserData'],data['senderId'])));
                    },
                    child: CachedNetworkImage(
                      imageUrl: data['UserData']['profilePic'],
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.08,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data['UserData']['First']} ${data['UserData']['Last']}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      GestureDetector(
                        onTap: () =>
                            _launchInEmailApp(data['UserData']['Email']),
                        child: Text(
                          data['UserData']['Email'],
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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${data['Title']}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "Apllication letter",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(data['message']),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
               Row(
                 children: [
                   IconButton(
                          onPressed: () async {
                            String? chatRoomId = await fetchOrCreateChatRoomId(
                                data['senderId'],
                                _authentication.currentUser!.uid);
                            if (chatRoomId != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailPage(
                                    currentUserUid:
                                        _authentication.currentUser!.uid,
                                    chatRoomId: chatRoomId,
                                    recipientUid: data['senderId'],
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error creating or fetching chat room!'),
                                ),
                              );
                            }
                          },
                          icon: Image.asset(
                              width: 30, height: 30, "asset/send.png")),
                              Text("Contact")
                 ],
               ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Position",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                  // padding: EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                      itemCount: data['Skill'].length,
                      itemBuilder: (context, index) {
                        return Text('${data['Skill'][index]}');
                      })),

                      
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      String? chatRoomId = await fetchOrCreateChatRoomId(
                          data['senderId'], _authentication.currentUser!.uid);
                      FirebaseFirestore.instance
                          .collection("Requests")
                          .doc(_authentication.currentUser!.uid)
                          .collection('messages')
                          .doc(requestId)
                          .delete();
                      // send rejection message
                      // _chat.sendmessage(
                      //     data['senderId'], "User request has rejected",chatRoomId!);
                      sendMessage(
                          "I hope this letter finds you well. I want to extend my sincere gratitude for your interest in collaborating with me on ${data['Title']} Project. I have carefully reviewed your proposal and deliberated on the potential synergies that could arise from such a collaboration.\After thoughtful consideration, however, I regret to inform you that I am unable to accept your request for collaboration at this time.",
                          chatRoomId!);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.clear_circled,
                      size: 70,
                      color: Color.fromARGB(255, 237, 124, 116),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () async {
                      String? chatRoomId = await fetchOrCreateChatRoomId(
                          data['senderId'], _authentication.currentUser!.uid);
                      FirebaseFirestore.instance
                          .collection("Requests")
                          .doc(_authentication.currentUser!.uid)
                          .collection('messages')
                          .doc(requestId)
                          .delete();
                      // send rejection message
                      // _chat.sendmessage(data['senderId'],
                      //     "User request has Accepted", chatRoomId!);
                      sendMessage(
                          "I am delighted to accept your invitation to collaborate on ${data['Title']} Project. It is truly an honor to have the opportunity to work together and contribute to the success of this initiative.",
                          chatRoomId!);
                      // add project to working on projects
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(data['senderId'])
                          .update({
                        'WorkingOnPro':
                            FieldValue.arrayUnion([data['projectId']])
                      }).then((value) {
                        print(
                            "Element added to the working list successfully.");
                      }).catchError((error) {
                        print(
                            "Failed to add element to the working list: $error");
                      });
              
                      FirebaseFirestore.instance
                          .collection("Project")
                          .doc(data['projectId'])
                          .update({
                        'Teams': FieldValue.arrayUnion([data['senderId']])
                      }).then((value) {
                        print(
                            "Element added to the Myproject teams list successfully.");
                      }).catchError((error) {
                        print(
                            "Failed to add element to the working list: $error");
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 70,
                      color: const Color.fromARGB(255, 156, 247, 159),
                    ),
                  ),
                 
                ],
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
