import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/Message/chatDetailPage.dart';
import 'package:skillswap/Message/chatRoomTab.dart';
import 'package:skillswap/Message/chatdetailrec.dart';


class JobTab extends StatefulWidget {
  final String currentUserUid;

  JobTab({required this.currentUserUid});

  @override
  _JobTabState createState() => _JobTabState();
}

class _JobTabState extends State<JobTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ChatRooms')
            .where('participants', arrayContains: widget.currentUserUid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No chat rooms found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chatRoom = snapshot.data!.docs[index];
              var participants = chatRoom['participants'] as List?;
              if (participants == null || participants.isEmpty) {
                return Container();
              }

              var recipientUid = participants.firstWhere(
                (uid) => uid != widget.currentUserUid,
                orElse: () => null,
              );

              if (recipientUid == null) {
                return Container();
              }

              var chatRoomId = chatRoom.id;

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('ChatRooms')
                    .doc(chatRoomId)
                    .collection('Messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .get(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> messageSnapshot) {
                  if (messageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  }
                  if (!messageSnapshot.hasData ||
                      messageSnapshot.data!.docs.isEmpty) {
                    return Container();
                  }

                  var lastMessage = messageSnapshot.data!.docs.first;
                  var messageText = lastMessage['message'];

                  bool isCurrentUserMessage =
                      lastMessage['sender_uid'] == widget.currentUserUid;

                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Recruiter')
                        .doc(recipientUid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container();
                      }
                      if (!userSnapshot.hasData || userSnapshot.data == null) {
                        return Container();
                      }

                      var userData = userSnapshot.data!.data();
                      if (userData is Map<String, dynamic>) {
                        var recipientName =
                            '${userData['First'] ?? ''} ${userData['Last'] ?? ''}';
                        var recipientProfilePic = userData['profilePic'] ?? '';

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(recipientProfilePic),
                            ),
                            title: Text(
                              recipientName,
                              style: TextStyle(
                                  fontWeight: isCurrentUserMessage
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    messageText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: isCurrentUserMessage
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (!isCurrentUserMessage)
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailPageRec(
                                    currentUserUid: widget.currentUserUid,
                                    chatRoomId: chatRoomId,
                                    recipientUid: recipientUid,
                                  ),
                                ),
                              ).then((_) {
                                setState(() {
                                  isCurrentUserMessage = true;
                                });
                              });
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
