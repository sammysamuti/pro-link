import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/Front/signin.dart';
import 'package:skillswap/Front/signin2.dart';
import 'package:skillswap/firebase/firebase.dart';
import 'package:skillswap/widgets/buttons.dart';
import 'package:skillswap/widgets/skillsdropdown.dart';
import 'package:skillswap/homepageRec/homepagerec.dart';

class SignUpRecPage extends StatefulWidget {
  const SignUpRecPage({Key? key}) : super(key: key);
  @override
  SignUpRecPageState createState() => SignUpRecPageState();
}

class SignUpRecPageState extends State<SignUpRecPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _linkedincontroller = TextEditingController();
  final _companynamecontroller = TextEditingController();
  late final UserController usercontroller;
  bool _isLoading = false;

  late final Firebase_Service _auth;
  List<String> _skillsPreference = [];

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height*0.03,),
                SizedBox(
                  height: height * 0.2,
                  child: Image.asset("asset/logo2.png"),
                ),
                  const Text(
                    "ProLink",
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
                        backgroundColor: Colors.white,
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
                                  width: 30, height: 30, "asset/camera.png")))
                    ]),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const FormText(
                      text: "First Name", alignment: Alignment.centerLeft),
                  CustomTextFormField(
                    width: width * 0.9,
                    height: height * 0.06,
                    hintText: "First Name",
                    controller: _firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First name';
                      }
                      return null;
                    },
                  ),
                  const FormText(
                      text: "Last Name", alignment: Alignment.centerLeft),
                  CustomTextFormField(
                    width: width * 0.9,
                    height: height * 0.06,
                    hintText: "Last Name",
                    controller: _lastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const FormText(
                      text: "Email", alignment: Alignment.centerLeft),
                  CustomTextFormField(
                    width: width * 0.9,
                    height: height * 0.06,
                    hintText: "abc@gmail.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),

                  const FormText(
                      text: "Password", alignment: Alignment.centerLeft),

                  CustomTextFormField(
                    width: width * 0.9,
                    height: height * 0.06,
                    hintText: "********",
                    controller: _passwordController,
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        // toggle password visibility
                        setState(() {
                          _passwordController.text =
                              _passwordController.text.replaceAll('•', '');
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8 || value.length > 16) {
                        return 'Password must be between 8 and 16 characters long';
                      }
                      return null;
                    },
                  ),

                  const FormText(
                      text: "Company Name", alignment: Alignment.centerLeft),

                  CustomTextFormField(
                    width: width * 0.9,
                    height: height * 0.06,
                    hintText: "Company name",
                    controller: _companynamecontroller,
                  ),

                  const FormText(
                      text: "LinkedIn", alignment: Alignment.centerLeft),

                  CustomTextFormField(
                    width: width * 0.9,
                    height: height * 0.06,
                    hintText: "Linkedin",
                    controller: _linkedincontroller,
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),
                  Dropdown(
                    skill: "Skill Preference",
                    onItemsSelected: (selectedItems) {
                      setState(() {
                        _skillsPreference = selectedItems;
                      });
                    },
                  ),
                  SizedBox(height: height * 0.03),
                  // Button("Sign Up", Colors.white, Color(0XFF2E307A), () {
                  //   if (_formKey.currentState!.validate()) {
                  //     // form is valid, submit the form
                  //     _signUp();
                  //   }
                  // }),
                  ButtonTwoLoading("Sign Up", Colors.white, Color(0XFF2E307A),
                      width * 0.8, height * 0.07, 16, () {
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      // form is valid, submit the form
                      _signUp();
                    }
                  }, _isLoading),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'already have an account? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0XFF7980C2),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage2()));
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF2E307A)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some action to take when the user presses the action button
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;
    String firstName = _firstnameController.text;
    String lastName = _lastnameController.text;
    String linkedin = _linkedincontroller.text;
    String companyName = _companynamecontroller.text;
    downloadUrl ??= "https://firebasestorage.googleapis.com/v0/b/skillswap-ad93c.appspot.com/o/images%2F2024-04-13%2015%3A36%3A50.046625.jpg?alt=media&token=2c1c5ed6-7304-41cd-9e71-c75d77c5a7df";

    User? user = await _auth.signUpWithEmailAndPasswordREC(
      firstName,
      lastName,
      email,
      password,
      downloadUrl!,
      linkedin,
      companyName,
      _skillsPreference,
      isRecruiter: true,
    );
    if (user != null) {
      await usercontroller.initializeRec(user.uid);
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomepageREC(user.uid)),
        (route) => false,
      );
      _showSnackBar("User is successfully created");
    } else {
      print("Some error happened on create user");
      _showSnackBar("Some error happened on create user");
    }
    setState(() {
      _isLoading = false;
    });
  }
}
