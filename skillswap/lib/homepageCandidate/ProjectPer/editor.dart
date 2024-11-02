import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/widgets/buttons.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth _authentication = FirebaseAuth.instance;
final userRef = firestore.collection('Users');
final proRef = firestore.collection('Project');
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

class TitleEdit extends StatefulWidget {
  final String title;
  final String projectid;
  const TitleEdit(this.title, this.projectid, {Key? key}) : super(key: key);

  @override
  State<TitleEdit> createState() => _TitleEditState();
}

class _TitleEditState extends State<TitleEdit> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Project Title'),
                content: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        width: width,
                        height: height * 0.07,
                        hintText: 'Project Title',
                        controller: titleController,
                      ),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (!titleController.text.isEmpty) {
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Project')
                            .doc(widget.projectid);
                        await docRef
                            .update({'ProjectTitle': titleController.text});
                        DocumentSnapshot snapshot = await docRef.get();
                            Map<String, dynamic> projectdata =
              snapshot.data() as Map<String, dynamic>;
                    var teams = projectdata['Teams'] as List<dynamic>?;
                      for(var key in teams!){
                        String? chatRoomId =
          await fetchOrCreateChatRoomId(key, _authentication.currentUser!.uid);
                sendMessage(
          "I hope this email finds you well. I wanted inform You that our Project title ${widget.title} has changed to ${titleController.text} do to some reasons",
          chatRoomId!,
          key);
                      };

                        titleController.text = '';
                      }
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(
          Icons.edit,
          size: 30,
        ));
  }
}


class DescriptionEdit extends StatefulWidget {
  final String description;
  final String projectid;
  const DescriptionEdit(this.description, this.projectid, {Key? key}) : super(key: key);

  @override
  State<DescriptionEdit> createState() => _DescriptionEditState();
}

class _DescriptionEditState extends State<DescriptionEdit> {
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Project description'),
                content: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormFieldTwo(
                        width: width,
                        height: height * 0.07,
                        hintText: 'Project description',
                        controller: descriptionController,
                        maxLine: 10,
                      ),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (!descriptionController.text.isEmpty) {
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Project')
                            .doc(widget.projectid);
                        await docRef
                            .update({'ProjectDes': descriptionController.text});
                        DocumentSnapshot snapshot = await docRef.get();
                            Map<String, dynamic> projectdata =
              snapshot.data() as Map<String, dynamic>;
                    var teams = projectdata['Teams'] as List<dynamic>?;
                      for(var key in teams!){
                        String? chatRoomId =
          await fetchOrCreateChatRoomId(key, _authentication.currentUser!.uid);
                sendMessage(
          "I hope this email finds you well. I wanted inform You that our Project description of Project ${projectdata['ProjectTitle']} has changed check it out",
          chatRoomId!,
          key);
                      };

                        descriptionController.text = '';
                      }
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(
          Icons.edit,
          size: 30,
        ));
  }
}


class AddSkill extends StatefulWidget {
  final String projectid;
  const AddSkill(this.projectid, {Key? key}) : super(key: key);

  @override
  State<AddSkill> createState() => _AddSkillState();
}

class _AddSkillState extends State<AddSkill> {
  TextEditingController skillController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('New Skill'),
                content: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        width: width,
                        height: height * 0.07,
                        hintText: 'Skill',
                        controller: skillController,
                      ),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (!skillController.text.isEmpty) {
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Project')
                            .doc(widget.projectid);
                        await docRef
                            .update({
                              'SkillReq': FieldValue.arrayUnion([skillController.text]),
                              });
                        
                           

                        skillController.text = '';
                      }
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(
          Icons.add_circle_outline_outlined,
          size: 30,
        ));
  }
}
