import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageRec/searchrec.dart';
import 'package:skillswap/homepageRec/udetail.dart';
import '../Message/chatDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRecruiter extends StatefulWidget {
  const HomeRecruiter({Key? key}) : super(key: key);

  @override
  State<HomeRecruiter> createState() => _HomeRecruiterState();
}

class _HomeRecruiterState extends State<HomeRecruiter> {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final UserController userController = Get.find();
  List<Map<String, dynamic>> usersWithMatchingSkills = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    List<Map<String, dynamic>> users = await userController
        .fetchUsersWithMatchingSkills(userController.userdata['Email']);
    setState(() {
      usersWithMatchingSkills = users;
    });
  }

  Future<String?> fetchOrCreateChatRoomId(String uid1, String uid2) async {
    List<String> participantUids = [uid1, uid2];
    participantUids.sort();

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
        });
        return chatRoomRef.id;
      } catch (e) {
        print('Error creating chat room: $e');
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        CupertinoIcons.text_justify,
                        size: 30,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchUser_Screen()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              'Search Users...',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CachedNetworkImage(
                    imageUrl: userController.userdata['profilePic'],
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
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Users with Specific Skills',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              usersWithMatchingSkills.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: usersWithMatchingSkills.length,
                      itemBuilder: (context, index) {
                        
                        return _buildUserRow(
                          usersWithMatchingSkills[index]['profilePic'],
                          usersWithMatchingSkills[index]['First'] +
                              ' ' +
                              usersWithMatchingSkills[index]['Last'],
                          usersWithMatchingSkills[index]['Bio'],
                          context,
                          usersWithMatchingSkills[index]['uid'],
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildUserRow(String? profileImage, String? username,
      String? skillDescription, BuildContext context, String? recipientUid) {
   
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(recipientUid!),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      profileImage != null ? NetworkImage(profileImage) : null,
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? 'Unknown',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      width: 130,
                      child: Text(
                        skillDescription ?? 'No description',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                print("Button pressed");
                String? chatRoomId = await fetchOrCreateChatRoomId(
                    _authentication.currentUser!.uid, recipientUid!);
                print(_authentication.currentUser!.uid);
                print(recipientUid!);
                if (chatRoomId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                        currentUserUid: _authentication.currentUser!.uid,
                        chatRoomId: chatRoomId,
                        recipientUid: recipientUid,
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
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0XFF2E307A)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
