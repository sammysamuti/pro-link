// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:skillswap/Chat/chat.dart';
// import 'package:skillswap/widgets/buttons.dart';

// class ChatPage extends StatefulWidget {
//   Map<String, dynamic> userdata;
//   String recieverid;
//   ChatPage({required this.recieverid, required this.userdata, super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final Chat _chat = Chat();
//   final FirebaseAuth _authentication = FirebaseAuth.instance;

//   void sendmessage(String recieverid, String message) async {
//     if (_messageController.text.isNotEmpty) {
//       await _chat.sendmessage(widget.recieverid, _messageController.text);
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: CachedNetworkImage(
//           imageUrl: widget.userdata['profilePic'],
//           imageBuilder: (context, imageProvider) => Container(
//             width: 50.0,
//             height: 50.0,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//             ),
//           ),
//           placeholder: (context, url) => Icon(Icons.person),
//           errorWidget: (context, url, error) => Icon(Icons.error),
//         ),
//         title: Text("${widget.userdata['First']} ${widget.userdata['Last']}"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left:20.0,right: 20,bottom:5,top: 20),
//         child: Column(
//           children: [
//             Expanded(child: _buildmessage()),
//             _buildmessageinput(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildmessage() {
//     return StreamBuilder(
//         stream: _chat.getmessage(
//             widget.recieverid, _authentication.currentUser!.uid),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text("Error" + snapshot.error.toString());
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text("Loading ...");
//           }

//           return ListView(
//             children: snapshot.data!.docs
//                 .map((document) => _messageItem(document))
//                 .toList(),
//           );
//         });
//   }

//   Widget _messageItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//     var alignment = (data['senderId'] == _authentication.currentUser!.uid)
//         ? Alignment.centerRight
//         : Alignment.centerLeft;

//     return Container(alignment: alignment, child: Text(data['message'],style: TextStyle(fontSize: 20),));
//   }

//   Widget _buildmessageinput() {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//             child: CustomTextFormField(
//           controller: _messageController,
//           width: width * 0.7,
//           height: height * 0.07,
//           hintText: "Send message",
//         )),
//         IconButton(
//             onPressed: () {
//               sendmessage(widget.recieverid, _messageController.text);
//             },
//             icon: Icon(Icons.send,size: 40,color:Color(0XFF2E307A) ,))
//       ],
//     );
//   }
// }
