import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillswap/Front/signin.dart';
import 'package:skillswap/widgets/buttons.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Text('Password reset link sent! Check your email'),
        );
      },
    ).then((_) {
     Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
        (route) => false,
      );
    });
  } on FirebaseAuthException catch (e) {
    print(e);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
                    SizedBox(
            height: height * 0.2,
            child: Image.asset("asset/logo2.png"),
                  ),
              SizedBox(
                    height: height * 0.1,
                  ),
              const Text(
                'Forget Password?',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              FormText(text: "Email", alignment: Alignment.topLeft),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: CustomTextFormField(
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
              ),
              SizedBox(
                height: 10,
              ),
              ButtonTwo("Reset", Colors.white,  Color(0XFF2E307A), width*0.8 , height*0.07, 16, passwordReset),
            ],
          ),
        ),
      ),
    );
  }
}