import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async'; // Import for Timer class
import 'package:skillswap/Front/recruiterORuser.dart';

class SlideModel {
  final String imagePath;
  final String text;

  const SlideModel({required this.imagePath, required this.text});
}

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  PageController pageController = PageController();
  Timer? timer;

  // ... existing code ...

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer =
        Timer.periodic(Duration(seconds: 20), (timer) => _handleSlideChange());
  }

 void _handleSlideChange() {
  if (currentIndex < slideData.length - 1) {
    pageController.nextPage(
      duration: Duration(milliseconds: 200), curve: Curves.linear);
  } else {
    timer?.cancel(); // Stop timer when reaching the last slide
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }
}


  // ... existing code for build method ...

  final List<SlideModel> slideData = [
    // ... your slide data here
    SlideModel(
        imagePath: 'asset/animation.json',
        text:
            'Welcome to ProLink!\nProLink serves as a dynamic platform connecting recruiters with individuals possessing various talents, as well as facilitating collaborations for those seeking project partners.'),
    SlideModel(
        imagePath: 'asset/animation.json',
        text:
            'The recruiter \nRecruiter page acts as a tool to assist recruiters in connecting with individuals who possess a diverse range of talents, enabling them to find the ideal candidates for their needs.'),
    SlideModel(
        imagePath: 'asset/animation.json',
        text:
            'The Collaborator\nUser page serves as a gateway for users to connect with potential collaborators for a wide array of projects, fostering partnerships across various fields and endeavors.'),
  ];

  void _handlePreviousSlide() {
    if (pageController.page!.round() > 0) {
      pageController.previousPage(
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      setState(() {
        currentIndex = pageController.page!.round();
      });
    }
  }

  void _handleNextSlide() {
    if (currentIndex < slideData.length - 1) {
      pageController.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      setState(() {
        currentIndex = pageController.page!.round();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Use Stack for positioning the skip button
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: slideData.length,
            itemBuilder: (context, index) => _buildSlide(slideData[index]),
          ),
          Positioned(
            top: 20.0, // Adjust top padding as needed
            right: 20.0, // Adjust right padding as needed
            child: TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WelcomePage())), // Replace MyHomePage with your app's home page
              child: Text(
                'Skip',
                style: TextStyle(color: Color(0XFF2E307A)),
              ),
            ),
          ),
          Positioned(
            bottom: 5.0, // Adjust padding as needed
            left: 20.0, // Adjust left padding as needed
            child: IconButton(
              onPressed: () => _handlePreviousSlide(),
              icon: Container(
                padding: EdgeInsets.all(5.0), // Adjust padding as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(
                      255, 218, 216, 216), // Set background color
                ),
                child: Icon(Icons.arrow_back,
                    color:  Color(0XFF2E307A)), // Set icon color
              ),
            ),
          ),
          Positioned(
            bottom: 5.0, // Adjust padding as needed
            right: 20.0, // Adjust right padding as needed
            child: IconButton(
              onPressed: () => _handleNextSlide(),
              icon: Container(
                padding: EdgeInsets.all(5.0), // Adjust padding as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:  Color(0XFF2E307A), // Set background color
                ),
                child: Icon(Icons.arrow_forward,
                    color: Colors.white), // Set icon color
              ),
            ),
          ),
          Positioned(
            bottom: 20.0, // Adjust padding as needed
            left:
                MediaQuery.of(context).size.width * 0.25, // Center horizontally
            right:
                MediaQuery.of(context).size.width * 0.25, // Center horizontally
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < slideData.length; i++)
                  buildSlideStatusDot(i),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSlideStatusDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: currentIndex == index ? 10.0 : 5.0, // Adjust dot size
      height: 5.0, // Adjust dot height
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            currentIndex == index ? Color(0XFF2E307A) : Colors.grey, // Adjust colors
      ),
    );
  }

  Widget _buildSlide(SlideModel slide) {
    return Stack(
      // Use another Stack for image and text positioning
      children: [
        Center(
          child: Lottie.asset(slide.imagePath,
              ),
        ), // Assuming full-screen image
        Positioned(
          bottom: 40.0, // Adjust bottom padding as needed
          left: 20.0, // Adjust left padding as needed
          right: 20.0, // Adjust right padding as needed
          child: Container(
            color: Colors.white
                .withOpacity(0.5), // Semi-transparent black background
            padding: EdgeInsets.all(10.0),
            child: Text(
              slide.text,
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ),
        ),
      ],
    );
  }
}
