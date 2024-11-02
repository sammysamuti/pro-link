import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skillswap/Front/recruiterORuser.dart';
import 'package:skillswap/Request/requestui.dart';
import 'package:skillswap/firebase/firebase_options.dart';
import 'package:skillswap/Front/onboarding1.dart';
import 'package:skillswap/homepageCandidate/home/Job/jobdetail.dart';
import 'package:skillswap/homepageCandidate/home/filter.dart';
import 'package:skillswap/homepageRec/postjobform.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, ),
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
      // home: PostJobForm(),
    );
  }
}
