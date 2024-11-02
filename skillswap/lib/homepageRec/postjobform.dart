import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/home/newskill.dart';
import '../firebase/firebase.dart';

import '../widgets/buttons.dart';

class PostJobForm extends StatefulWidget {
  const PostJobForm({Key? key}) : super(key: key);

  @override
  State<PostJobForm> createState() => _PostJobFormState();
}

class _PostJobFormState extends State<PostJobForm> {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final _jobtitleController = TextEditingController();
  final _jobdescriptionController = TextEditingController();
  final _requirementcontroller = TextEditingController();
  final _locationcontroller = TextEditingController();
  final _salaryrangecontroller = TextEditingController();
  late final UserController usercontroller;
  late final ProjectController projectController;
  late final Firebase_Service _auth;
  List<Map<String,dynamic>> _requirements = [];
  bool _isLoading = false;

  bool _obscureText = true;
  String? imagePath;
  File? _image;
  String? downloadUrl;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // For mobile platforms, set the image directly
    final imageTemp = File(image.path);
    setState(() {
      imagePath = imageTemp.path;
      _image = imageTemp;
    });
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now()}.jpg');

    try {
      // Upload the image to Firebase Storage
      await storageReference.putFile(_image!);

      // Retrieve the download URL of the uploaded image
      downloadUrl = await storageReference.getDownloadURL();
    } catch (e) {
      // Handle any errors that occur during the upload process
      print('Error uploading image: $e');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _auth = Firebase_Service(context);
    usercontroller = Get.put(UserController());
    projectController = Get.put(ProjectController());
    super.initState();
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
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Create Job Posting',
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
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40.0,
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath!))
                            : null,
                        child: imagePath == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                              )
                            : null,
                      ),
                      Positioned(
                        top: 45,
                        right: -10,
                        child: IconButton(
                          onPressed: pickImage,
                          icon: Image.asset(
                            "asset/camera.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const FormText(
                  text: "Job Title",
                  alignment: Alignment.centerLeft,
                ),
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
                  text: "Job Description",
                  alignment: Alignment.centerLeft,
                ),
                CustomTextFormFieldTwo(
                  width: width * 0.9,
                  height: height * 0.06,
                  hintText: "Job Description",
                  controller: _jobdescriptionController,
                  maxLine: null,
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
               
                SizedBox(
                  height: height * 0.02,
                ),
                const FormText(
                  text: "Location",
                  alignment: Alignment.centerLeft,
                ),
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
                  text: "Salary Range",
                  alignment: Alignment.centerLeft,
                ),
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
                  height: height*0.2,
                  child: ListView.builder(
                    itemCount: _requirements.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_requirements[index]['name']),
                          Text(_requirements[index]['level']),
                         IconButton(onPressed: (){
                        setState(() {
                           _requirements.removeAt(index);
                        });
                         }, icon: Icon(Icons.remove))
                        ],
                      ) ;
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ButtonTwoLoading(
                  "Post",
                  Colors.white,
                  Color(0XFF2E307A),
                  width * 0.8,
                  height * 0.07,
                  16,
                  () {
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      // form is valid, submit the form
                      _postJob();
                    }
                  },
                  _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _postJob() async {
    setState(() {
      _isLoading = true;
    });

    try {
      
      // Get the current user's ID
      String userId = _authentication.currentUser!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Recruiter')
          .doc(userId)
          .get();

      // Extract the company name from the user data
      String companyName = userSnapshot.get('CompanyName');

      // Add the job post to Firestore, including the user's ID and company name
      await _auth.addJobPost(
        _jobtitleController.text,
        _jobdescriptionController.text,
        _requirements,
        _locationcontroller.text,
        _salaryrangecontroller.text,
        downloadUrl ??=  "https://firebasestorage.googleapis.com/v0/b/skillswap-ad93c.appspot.com/o/images%2F2024-04-13%2016%3A24%3A57.976252.jpg?alt=media&token=e606f205-f72a-4ab5-b759-60e19f44b5c0", // Use the downloadUrl of the uploaded image
        userId, // Pass the user's ID
        companyName, // Pass the company name
      );

      // Reset the form and loading state
      _formKey.currentState!.reset();
      setState(() {
        _isLoading = false;
        imagePath = null;
        _image = null;
        downloadUrl = null;
      });

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Job post created successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Pop the page
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors
      print('Error posting job: $e');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error posting job. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
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
                     _requirements.add({
                        'name': newskill.text,
                        'level': level,
                      });

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
