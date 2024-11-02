import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/Chat/chat.dart';
import 'package:skillswap/Request/requestdetail.dart';
import 'package:skillswap/Request/requestui.dart';
import 'package:skillswap/Request/sendrequest.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  RequestSend _request = RequestSend();
  // final Chat _chat = Chat();
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

 

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Expanded(child: _buildRequests()),
    );
  }

  Widget _buildRequests() {
       
    return StreamBuilder(
        stream: _request.getrequest(_authentication.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error" + snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          return SizedBox(
            child: ListView(
              children: snapshot.data!.docs
                  .map((document) => _sendRequest(document))
                  .toList(),
            ),
          );
        });
  }

  Widget _sendRequest(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String requestId = document.id;

    // void removeRequest() async {
    //   print("start");
    //   await _request.removeRequest(_authentication.currentUser!.uid, requestId);
    //   print("end");
    // }

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

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RequestDetail(data, requestId)));
          },
          child: Container(
            width: width * 0.9,
            height: height * 0.18,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImage(
                          imageUrl: data['UserData']['profilePic'],
                          imageBuilder: (context, imageProvider) => Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Icon(CupertinoIcons.person),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Text(
                          '${data['UserData']['First']} ${data['UserData']['Last']}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async{
                                String? chatRoomId = await fetchOrCreateChatRoomId(
                          data['senderId'], _authentication.currentUser!.uid);
                                print(document.id);
                                FirebaseFirestore.instance
                                    .collection("Requests")
                                    .doc(_authentication.currentUser!.uid)
                                    .collection('messages')
                                    .doc(requestId)
                                    .delete();
                                // send rejection message
                                // _chat.sendmessage(data['senderId'],
                                //     "User request has rejected");
                                sendMessage("I hope this letter finds you well. I want to extend my sincere gratitude for your interest in collaborating with me on ${data['Title']} Project. I have carefully reviewed your proposal and deliberated on the potential synergies that could arise from such a collaboration.\After thoughtful consideration, however, I regret to inform you that I am unable to accept your request for collaboration at this time.", chatRoomId!);
                                // Navigator.pop(context);
                              },
                              icon: Icon(
                                CupertinoIcons.clear_circled,
                                size: 45,
                                color: Color.fromARGB(255, 237, 124, 116),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            IconButton(
                              onPressed: () async{
                                 String? chatRoomId = await fetchOrCreateChatRoomId(
                          data['senderId'], _authentication.currentUser!.uid);
                                FirebaseFirestore.instance
                                    .collection("Requests")
                                    .doc(_authentication.currentUser!.uid)
                                    .collection('messages')
                                    .doc(requestId)
                                    .delete();
                                FirebaseFirestore.instance
                                    .collection("Requests")
                                    .doc(_authentication.currentUser!.uid)
                                    .collection('messages')
                                    .doc(requestId)
                                    .delete();
                                // send rejection message
                                // _chat.sendmessage(data['senderId'],
                                //     "User request has Accepted");
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

                              FirebaseFirestore.instance
                          .collection("Users")
                          .doc( _authentication.currentUser!.uid)
                          .update({
                        'Teams':
                            FieldValue.arrayUnion([data['senderId']])
                      }).then((value) {
                        print(
                            "Element added to the Myproject teams list successfully.");
                      }).catchError((error) {
                        print(
                            "Failed to add element to the working list: $error");
                      });

                                sendMessage("I am delighted to accept your invitation to collaborate on ${data['Title']} Project. It is truly an honor to have the opportunity to work together and contribute to the success of this initiative.", chatRoomId!);
                                //  Navigator.pop(context);
                              },
                              icon: Icon(
                                CupertinoIcons.check_mark_circled,
                                size: 45,
                                color:Color.fromARGB(255, 146, 248, 150),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      ' ${data['message']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
