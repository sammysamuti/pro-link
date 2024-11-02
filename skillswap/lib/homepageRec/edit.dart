import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/widgets/buttons.dart';
import 'package:get/get.dart';

class PostJobFormEdit extends StatefulWidget {
  final String initialId;
  const PostJobFormEdit({
    Key? key,
    required this.initialId,
  }) : super(key: key);

  @override
  State<PostJobFormEdit> createState() => _PostJobFormEditState();
}

class _PostJobFormEditState extends State<PostJobFormEdit> {
  ProjectController projectController = Get.put(ProjectController());
  String? imagePath;
  File? _image;
  String? downloadUrl;
  List<dynamic> _requiredSkills = [];
  bool _isLoading = false;
  String? downImage;

  final _jobtitleController = TextEditingController();
  final _jobdescriptionController = TextEditingController();
  final _locationcontroller = TextEditingController();
  final _salaryrangecontroller = TextEditingController();
  List<dynamic> _requirements = [];

  final _formKey = GlobalKey<FormState>();

  jobData(String docid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('JobPosts')
          .doc(docid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> jobdata = snapshot.data() as Map<String, dynamic>;

        downImage = jobdata['imageUrl'];
        _jobtitleController.text = jobdata['title'];
        _jobdescriptionController.text = jobdata['description'];
        _locationcontroller.text = jobdata['location'];
        _salaryrangecontroller.text = jobdata['salaryRange'];
        _requirements = jobdata['requirements'];
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeJobData();
  }

  Future<void> _initializeJobData() async {
    await jobData(widget.initialId);
    setState(() {
      _requirements;
    });
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() {
      _image = imageTemp;
    });

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now()}.jpg');

    try {
      await storageReference.putFile(_image!);
      downloadUrl = await storageReference.getDownloadURL();

      print('Download URL: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey, // Added key for form validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Edit Job Post Detail',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Center(
                  child: Stack(children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (downImage != null
                              ? NetworkImage(downImage!)
                              : null),
                    ),
                    Positioned(
                      top: 45,
                      right: -10,
                      child: IconButton(
                        onPressed: pickImage,
                        icon: Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const FormText(
                    text: "Job Title", alignment: Alignment.centerLeft),
                CustomTextFormField(
                  width: width * 0.9,
                  height: height * 0.06,
                  hintText: "Job Title",
                  controller: _jobtitleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Job Title';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const FormText(
                    text: "Job Description", alignment: Alignment.centerLeft),
                CustomTextFormField(
                  width: width * 0.9,
                  height: height * 0.06,
                  hintText: "Job Description",
                  controller: _jobdescriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Job Description';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const FormText(
                    text: "Location", alignment: Alignment.centerLeft),
                CustomTextFormField(
                  width: width * 0.9,
                  height: height * 0.06,
                  hintText: "Location",
                  controller: _locationcontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Location';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const FormText(
                    text: "Salary Range", alignment: Alignment.centerLeft),
                CustomTextFormField(
                  width: width * 0.9,
                  height: height * 0.06,
                  hintText: "Salary Range",
                  controller: _salaryrangecontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Salary Range';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FormText(
                      text: "Requirements",
                      alignment: Alignment.centerLeft,
                    ),
                    AddReq(),
                  ],
                ),
                SizedBox(
                  height: height * 0.2,
                  child: ListView.builder(
                    itemCount: _requirements.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_requirements[index]['name']),
                          Text(_requirements[index]['level']),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _requirements.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.remove))
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ButtonTwoLoading("Update", Colors.white, Color(0XFF2E307A),
                    width * 0.8, height * 0.07, 16, () {
                  if (_formKey.currentState!.validate()) {
                    _postJob();
                  }
                }, _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _postJob() {
    // Update Firestore document with new values

    FirebaseFirestore.instance
        .collection('JobPosts')
        .doc(widget.initialId)
        .update({
      'imageUrl': downloadUrl ?? downImage,
      'description': _jobdescriptionController.text,
      'location': _locationcontroller.text,
      'salaryRange': _salaryrangecontroller.text,
      'title': _jobtitleController.text,
      'requirements': _requirements,
    }).then((_) {
      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Job post updated successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update job post: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Widget AddReq() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final TextEditingController newskill = TextEditingController();
    String level = "Beginner";
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
                      if (!newskill.text.isEmpty) {
                        setState(() {
                          _requirements
                              .add({'name': newskill.text, 'level': level});
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
