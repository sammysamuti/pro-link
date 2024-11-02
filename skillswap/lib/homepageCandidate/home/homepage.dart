import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Message/message.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/createProject.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/personalproject.dart';
import 'package:skillswap/homepageCandidate/home/homescreen.dart';
// import 'package:skillswap/homepageCandidate/homescreen.dart';
import 'package:skillswap/Request/message.dart';
import 'package:skillswap/homepageCandidate/home/profile.dart';
import 'package:skillswap/homepageCandidate/Search/search.dart';
// import 'package:skillswap/homepageCandidate/recentproject.dart';
import 'package:skillswap/homepageCandidate/home/sidebar.dart';

class Homepage extends StatefulWidget {
  final String userid;

  Homepage(this.userid,{Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PageController _pageController;
  late final ProjectController projectController;
  int _currentPageIndex = 0;
  final UserController usercontroller = Get.find();
  final FirebaseAuth _authentication = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    // usercontroller = Get.put(UserController(widget.userid));
    // projectController =
    //     Get.put(ProjectController(usercontroller.userdata['MyProjects']));
    _pageController = PageController(initialPage: _currentPageIndex);
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      body:SafeArea(
            bottom: false,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                HomeScreen(),
                MyProjects(),
                // ChatPage(),
                MessagePage(currentUserUid: _authentication.currentUser!.uid),
                ProfilePage(),
              ],
            ),
          ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color.fromARGB(255, 237, 241, 245),
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0, // Adjust the margin as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.house, size: 30),
              onPressed: () {
                _onItemTapped(0);
              },
              color: _currentPageIndex == 0 ? Color(0XFF2E307A) : Colors.grey,
            ),
            IconButton(
              icon: Icon(CupertinoIcons.folder, size: 30),
              onPressed: () {
                _onItemTapped(1);
              },
              color: _currentPageIndex == 1 ? Color(0XFF2E307A) : Colors.grey,
            ),
            IconButton(
              icon: Icon(CupertinoIcons.chat_bubble_2, size: 30),
              onPressed: () {
                _onItemTapped(2);
              },
              color: _currentPageIndex == 2 ? Color(0XFF2E307A) : Colors.grey,
            ),
            IconButton(
              icon: Icon(CupertinoIcons.person, size: 30),
              onPressed: () {
                _onItemTapped(3);
              },
              color: _currentPageIndex == 3 ? Color(0XFF2E307A) : Colors.grey,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateProjectPage(),
            ),
          );
        },
        child: Icon(Icons.add, color: Color(0XFF2E307A), size: 30),
        shape: CircleBorder(),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}


