import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/Message/chatRoomTab.dart';
import 'package:skillswap/Message/jobtab.dart';
import 'package:skillswap/Message/message.dart';
import 'package:skillswap/Request/message.dart';

class MessagePage extends StatefulWidget {
  final String currentUserUid;

  MessagePage({required this.currentUserUid});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int collaborationRequestsCount = 0;
  int incomingMessagesCount = 0;

  @override
  void initState() {
    super.initState();
    // Fetch collaboration requests and incoming messages count
    fetchCounts();
  }

  void fetchCounts() async {
    // Retrieve collaboration requests count
    QuerySnapshot collaborationRequestsSnapshot = await FirebaseFirestore
        .instance
        .collection('CollaborationRequests')
        .where('recipientUid', isEqualTo: widget.currentUserUid)
        .get();
    setState(() {
      collaborationRequestsCount = collaborationRequestsSnapshot.docs.length;
    });

    // Retrieve incoming messages count
    QuerySnapshot incomingMessagesSnapshot = await FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('participants', arrayContains: widget.currentUserUid)
        .get();
    int unreadMessagesCount = 0;
    for (QueryDocumentSnapshot roomSnapshot in incomingMessagesSnapshot.docs) {
      QuerySnapshot messagesSnapshot = await roomSnapshot.reference
          .collection('Messages')
          .where('isRead', isEqualTo: false)
          .where('sender_uid', isNotEqualTo: widget.currentUserUid)
          .get();
      unreadMessagesCount += messagesSnapshot.docs.length;
    }
    setState(() {
      incomingMessagesCount = unreadMessagesCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Messages'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {},
                tooltip: 'Notifications',
              ),
              if (collaborationRequestsCount + incomingMessagesCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${collaborationRequestsCount + incomingMessagesCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                tabs: [
                  Tab(text: 'Collaboration Requests'),
                  Tab(text: 'Chat Rooms'),
                  Tab(text:"Job" ,)
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Collaboration Requests Tab
                  ChatPage(),
                  // Chat Rooms Tab
                  ChatRoomTab(currentUserUid: widget.currentUserUid),
                 JobTab(currentUserUid: widget.currentUserUid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


