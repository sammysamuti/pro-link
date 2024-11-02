import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/home/profile.dart';
import 'package:skillswap/pages/aboutus.dart';
import 'package:skillswap/pages/help.dart';
import 'package:skillswap/pages/privacyPolicy.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key? key,
  }) : super(key: key);

  Widget buildSettingItem({
    IconData? icon,
    String? title,
    required VoidCallback navigate,
  }) {
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: navigate,
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10.0),
            Text(
              title ?? '',
              style: TextStyle(color: Colors.black),
            ),
            const Spacer(),
            const Text('English', style: TextStyle(color: Colors.black)),
            const SizedBox(width: 10.0),
            Icon(Icons.navigate_next, color: Colors.black),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: const Row(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 90.0,
                width: 390,
                child: GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0XFF7980C2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 20.0,
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: userController.userdata['profilePic'],
                          imageBuilder: (context, imageProvider) => Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Icon(Icons.person),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userController.userdata['First']} ${userController.userdata['Last']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '${userController.userdata['Email']}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.navigate_next, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: Color.fromARGB(255, 212, 202, 202),
                thickness: 1.0,
                indent: 30.0,
                endIndent: 30.0,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 40.0, top: 10.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSettingItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      navigate: () {}),
                  const SizedBox(height: 20.0),
                  buildSettingItem(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      navigate: () {}),
                  const SizedBox(height: 20.0),
                  buildSettingItem(
                    icon: Icons.privacy_tip_sharp,
                    title: 'Privacy',
                    navigate: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyPolicyPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  buildSettingItem(
                    icon: Icons.help_center,
                    title: 'Help Center',
                    navigate: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  buildSettingItem(
                    icon: Icons.info,
                    title: 'About Us',
                    navigate: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUs()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
