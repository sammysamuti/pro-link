import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/homepageCandidate/Search/persondetail.dart';
import 'package:skillswap/Chat/chatpage.dart';
import 'package:skillswap/Message/chatDetailPage.dart';

class TeamsProfile extends StatelessWidget {
  Map<String, dynamic> userdata;
  String userid;

  TeamsProfile(this.userdata, this.userid, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PersonalDetail(userdata, userid)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height * 0.1,
          width: width,
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: userdata['profilePic'],
                imageBuilder: (context, imageProvider) => Container(
                  width: 50.0,
                  height: 50.0,
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
                width: width * 0.02,
              ),
              Expanded(
                child: InkWell(
                  // onTap: () {
                  //  _dialogBuilder(context, userdata);
                  // },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${userdata['First']} ${userdata['Last']}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${userdata['Bio']}',
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed:() async {
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
                  icon: Image.asset(width: 30, height: 30, "asset/send.png"))
            ],
          ),
        ),
      ),
    );
  }
  
}



