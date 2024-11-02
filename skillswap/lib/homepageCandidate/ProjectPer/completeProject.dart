import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/home/homepage.dart';
// import 'package:skillswap/homepageCandidate/homepage.dart';
// import 'package:skillswap/homepageCandidate/homescreen.dart';
import 'package:skillswap/widgets/buttons.dart';

class CompleteProject extends StatefulWidget {
  String title;
  List<dynamic> teams;
  String projectid;
  CompleteProject(this.title, this.teams, this.projectid, {super.key});

  @override
  State<CompleteProject> createState() => _CompleteProjectState();
}

class _CompleteProjectState extends State<CompleteProject> {
  UserController userController = UserController();
  Map<String, int> ratings = {};
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController url = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            FormText(text: "Project Link", alignment: Alignment.centerLeft),
            CustomTextFormField(width: width, height: height*0.07, hintText: "Project Link", controller: url),
            Expanded(
              child: ListView.builder(
                itemCount: widget.teams.length,
                itemBuilder: (context, index) {
                  String teamMemberId = widget.teams[index];
                  return StreamBuilder<DocumentSnapshot>(
                    stream: userController.getuserdata(teamMemberId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.hasData && snapshot.data!.exists) {
                          // Document exists, use its data
                          var userData = snapshot.data!.data();
                          return Rate(
                              userData as Map<String, dynamic>, teamMemberId);
                        } else {
                          return Text('User data not found');
                        }
                      }
                    },
                  );
                },
              ),
            ),
            ButtonTwo("Rate", Colors.white, Color(0XFF2E307A), width * 0.7, height * 0.07, 16, () {
              rateTeams();
              ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Project Completed!'),
                        duration: Duration(seconds: 2), // Adjust the duration as needed
                      ),
                    );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Homepage(_authentication.currentUser!.uid)),
                (route) => false,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget Rate(final Map<String, dynamic> userdata, final String teamMemberId) {
    int selectedStars =
        ratings[teamMemberId] ?? 0; // Use stored rating or default to 0
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              imageUrl: userdata['profilePic'],
              imageBuilder: (context, imageProvider) => Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Icon(Icons.person),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    setState(() {
                      selectedStars = index + 1;
                      ratings[teamMemberId] = selectedStars;
                    });
                  },
                  icon: Icon(
                    index < selectedStars ? Icons.star : Icons.star_border,
                    color: index < selectedStars ? Colors.amber : null,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text('${userdata['First']} ${userdata['Last']}'),
      ],
    );
  }

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

  void sendMessage(String message, String chatroom, String reciever) async {
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
        'recipient_uid': reciever,
        'readBy': [
          _authentication.currentUser!.uid
        ], // Ensure readBy field is set initially
      });
    }
  }

  void rateTeams() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final proRef = firestore.collection('Project').doc(widget.projectid);
    final userRef = firestore.collection('Users');
    final completedRef = firestore.collection('CompletedProjects');

    final docSnapshot = await proRef.get();
    final data = docSnapshot.data();

    await firestore
        .collection("CompletedProjects")
        .doc(widget.projectid)
        .set(data!);

        if(!url.text.isEmpty){
          DocumentReference docRef = FirebaseFirestore.instance
                            .collection('CompletedProjects')
                            .doc(widget.projectid);
          await docRef
                    .update({
                      'Url': url.text,
                      });           
        }

    firestore.collection('Project').doc(widget.projectid).delete();

    ratings.forEach((key, value) async {
      DocumentSnapshot doc = await userRef.doc(key).get();
      List<dynamic> starsList = doc['Star']?? [];

      // Calculate the average of the stars
      double totalStars = 0;
      for (var star in starsList) {
        totalStars += star;
      }
      totalStars += value;
      double averageStars = totalStars / (starsList.length+1);
      await userRef.doc(key).update({
        'WorkingOnPro': FieldValue.arrayRemove([widget.projectid]),
        'Star': FieldValue.arrayUnion([value]),
        'Rate':averageStars
      });

      String? chatRoomId =
          await fetchOrCreateChatRoomId(key, _authentication.currentUser!.uid);
      sendMessage(
          "I hope this email finds you well. I wanted to take a moment to express my heartfelt gratitude for your invaluable assistance with ${widget.title}. Your expertise, guidance, and support were instrumental in bringing our project to fruition. you have got ${value} stars Thank you",
          chatRoomId!,
          key);

      await userRef.doc(key).update({
        'CompletedProject': FieldValue.arrayUnion([
          {'projectId': widget.projectid, 'rate': value}
        ])
      });
    });

    // Remove from the owner's WorkingOnPro list
    await userRef.doc(_authentication.currentUser!.uid).update({
      'MyProjects': FieldValue.arrayRemove([widget.projectid])
    });

    // Add to the owner's CompletedProject list
    await userRef.doc(_authentication.currentUser!.uid).update({
      'CompletedProject': FieldValue.arrayUnion([
        {
          'projectId': widget.projectid,
          'rate': 6 // Assuming 6 is the owner's rating
        }
      ])
    });
  }
}
