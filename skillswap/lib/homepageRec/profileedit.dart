import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/widgets/buttons.dart';

class NewSkill extends StatefulWidget {
  NewSkill({Key? key}) : super(key: key);

  @override
  _NewSkillState createState() => _NewSkillState();
}

class _NewSkillState extends State<NewSkill> {
  final TextEditingController newskill = TextEditingController();
  String level = "Beginner";
  final FirebaseAuth _authentication = FirebaseAuth.instance;

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
                          width: width * 0.8,
                          height: height * 0.05,
                          hintText: "Skill",
                          controller: newskill),
                      ListTile(
                        title: Text('Beginner'),
                        // Define value property within ListTile
                        leading: Radio(
                          value: 'Beginner',
                          groupValue: level, // Group for radio buttons
                          onChanged: (value) =>
                              setState(() => level = value as String),
                        ),
                      ),
                      ListTile(
                        title: Text('Intermediate'),
                        // Define value property within ListTile
                        leading: Radio(
                          value: 'Intermediate',
                          groupValue: level,
                          onChanged: (value) =>
                              setState(() => level = value as String),
                        ),
                      ),
                      ListTile(
                        title: Text('Advanced'),
                        // Define value property within ListTile
                        leading: Radio(
                          value: 'Advanced',
                          groupValue: level,
                          onChanged: (value) =>
                              setState(() => level = value as String),
                        ),
                      ),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      print(newskill.text);
                      if (!newskill.text.isEmpty) {
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Recruiter')
                            .doc(_authentication.currentUser!.uid);
                        await docRef.update({
                          'Skills': FieldValue.arrayUnion([
                            {'level': level, 'skill': newskill.text}
                          ]),
                        });

                        newskill.text = '';
                        level = "Beginner";
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







class LinkedInEdit extends StatefulWidget {
  final String linkedin;
  const LinkedInEdit(this.linkedin,{Key? key}) : super(key: key);

  @override
  State<LinkedInEdit> createState() => _LinkedInEditState();
}

class _LinkedInEditState extends State<LinkedInEdit> {
  TextEditingController linkedinController = TextEditingController();
    final FirebaseAuth _authentication = FirebaseAuth.instance;
  
  @override
  void initState() {
    super.initState();
    linkedinController.text = widget.linkedin;
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
                title: Text('LinkedIn'),
                content: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                          width: width ,
                          height: height * 0.05,
                          hintText: "handle",
                          controller: linkedinController),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (!linkedinController.text.isEmpty) {
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Recruiter')
                            .doc(_authentication.currentUser!.uid);
                        await docRef.update({
                          'Linkedin':linkedinController.text
                        });

                        linkedinController.text = '';
                      
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



class NameEdit extends StatefulWidget {
  final String first;
  final String last;
  const NameEdit(this.first,this.last,{Key? key}) : super(key: key);

  @override
  State<NameEdit> createState() => _NameEditState();
}

class _NameEditState extends State<NameEdit> {
  TextEditingController nameController = TextEditingController();
    final FirebaseAuth _authentication = FirebaseAuth.instance;
  
  @override
  void initState() {
    super.initState();
    nameController.text = widget.first+" "+widget.last;
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
                title: Text('Full Name'),
                content: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                          width: width ,
                          height: height * 0.05,
                          hintText: "handle",
                          controller: nameController),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (!nameController.text.isEmpty) {
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('Recruiter')
                            .doc(_authentication.currentUser!.uid);
                              int spaceIndex = nameController.text.indexOf(" ");
                       
                            if (spaceIndex != -1) {
                            
                            String first = nameController.text.substring(0, spaceIndex);

                            String last = nameController.text.substring(spaceIndex + 1);
                        await docRef.update({
                          'First':first,
                          'Last':last
                        });}
                        nameController.text = '';
                      
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
          size: 20,
        ));
  }
}

 

 

                          