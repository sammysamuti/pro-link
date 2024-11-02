import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:skillswap/Message/chatDetailPage.dart';

class ChatDetailPageRec extends StatefulWidget {
  final String currentUserUid;
  final String chatRoomId;
  final String recipientUid;

  ChatDetailPageRec({
    required this.currentUserUid,
    required this.chatRoomId,
    required this.recipientUid,
  });

  @override
  _ChatDetailPageRecState createState() => _ChatDetailPageRecState();
}

class _ChatDetailPageRecState extends State<ChatDetailPageRec> {
  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? recipientName;
  String? recipientProfileImageURL;
  bool _showEmojiPicker = true;

  @override
  void initState() {
    super.initState();
    fetchRecipientData();
  }

  void fetchRecipientData() async {
    DocumentSnapshot recipientDoc =
        await firestore.collection('Recruiter').doc(widget.recipientUid).get();

    setState(() {
      if (widget.recipientUid == widget.currentUserUid) {
        recipientName = "Saved Messages";
      } else {
        recipientName =
            (recipientDoc['First'] ?? '') + ' ' + (recipientDoc['Last'] ?? '');
      } // Assuming name is stored in Firestore
    });

    // Fetch profile image URL from Firestore
    String profileImageURL = recipientDoc['profilePic'] ?? '';
    if (profileImageURL.isNotEmpty) {
      setState(() {
        recipientProfileImageURL = profileImageURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: recipientProfileImageURL != null
                  ? NetworkImage(recipientProfileImageURL!)
                  : AssetImage('asset/profile.png'),
            ),
            SizedBox(width: 8),
            Text(
              recipientName != null ? recipientName! : 'Loading...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firestore
                  .collection('ChatRooms')
                  .doc(widget.chatRoomId)
                  .collection('Messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isCurrentUser =
                          message['sender_uid'] == widget.currentUserUid;
                      bool isReadByCurrentUser =
                          (message['readBy'] as List<dynamic>? ?? [])
                              .contains(widget.currentUserUid);
                      bool isReadByOtherUser =
                          (message['readBy'] as List<dynamic>? ?? []).length >
                              1;

                      // Update readBy field if message is not read by current user
                      if (!isReadByCurrentUser && !isCurrentUser) {
                        firestore
                            .collection('ChatRooms')
                            .doc(widget.chatRoomId)
                            .collection('Messages')
                            .doc(message.id)
                            .update({
                          'readBy':
                              FieldValue.arrayUnion([widget.currentUserUid])
                        });
                      }

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: isCurrentUser
                                      ? Radius.circular(12.0)
                                      : Radius.zero,
                                  topRight: isCurrentUser
                                      ? Radius.zero
                                      : Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0),
                                ),
                                color: isCurrentUser
                                    ? Color(0XFF7980C2)
                                    : Color(0XFF2E307A),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      message['message'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize
                                        .min, // Set mainAxisSize to min

                                    children: [
                                      Container(
                                        child: Text(
                                          _formatTimestamp(
                                              message['timestamp']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      isCurrentUser
                                          ? Icon(
                                              isReadByOtherUser
                                                  ? Icons.done_all
                                                  : Icons.done,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: Stack(
                      children: [
                        TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                          ),
                        ),
                        if (_showEmojiPicker)
                          Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: MediaQuery.of(context).size.height *
                                  0.2, // Adjust height as needed
                              child: EmojiPicker(
                                onEmojiSelected: (category, emoji) {
                                  _messageController.text += emoji.emoji;
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      // Add the message to Firestore
      DocumentReference docRef = await firestore
          .collection('ChatRooms')
          .doc(widget.chatRoomId)
          .collection('Messages')
          .add({
        'message': message,
        'timestamp': Timestamp.now(),
        'sender_uid': widget.currentUserUid,
        'recipient_uid': widget.recipientUid,
        'readBy': [
          widget.currentUserUid
        ], // Ensure readBy field is set initially
      });

      _messageController.clear();
    }
  }
}
