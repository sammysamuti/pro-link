import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMember {
  String name;
  AssetImage profilePhotoPath; // Change String to AssetImage
  String bio;
  String email;
  String linkedin;

  TeamMember({
    required this.name,
    required this.profilePhotoPath,
    this.bio = "",
    this.email = "",
    this.linkedin = "",
  });
}

class AboutUs extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Enkutatash',
      profilePhotoPath: AssetImage('asset/enkutatash.jpg'),
      bio:
          "I am 3rd year software engineering student,A2Svian,and flutter developer.",
      email: "enkutatasheshetu96@gmail.com",
      linkedin: "https://linkedin.com/in/enkutatash-eshetu-07159b240",
    ),
    TeamMember(
      name: 'Samiya M.',
      profilePhotoPath: AssetImage('asset/samiyaM.jpg'),
      bio: "I am 4th year software engineering student, flutter developer.",
      email: "samiyamo1118@gmail.com",
      linkedin: "https://www.linkedin.com/in/samiya-mohammedawol-42064b297/",
    ),
    TeamMember(
      name: 'Yetnayet',
      profilePhotoPath: AssetImage('asset/yeti.jpg'),
      bio:
          "I am 3rd year software engineering student,A2Svian,and flutter developer.",
      email: "lakewyetnayet93@gmail.com",
      linkedin: "https://www.linkedin.com/in/yetnayet-lakew-417441256",
    ),
    TeamMember(
      name: 'Sumeya',
      profilePhotoPath: AssetImage('asset/sumaya.jpg'),
      bio: "I am 4th year software engineering student, flutter developer.",
      email: "somalistiniyah@gmail.com",
      linkedin:
          "https://www.linkedin.com/in/sumaya-omar-a40803270?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app",
    ),
    TeamMember(
      name: 'Elsabeth',
      profilePhotoPath: AssetImage('asset/elsa.jpg'),
      bio: "I am 4th year,software engineering student,flutter developer.",
      email: "elsabethzeleke1000@gmail.com",
      linkedin: "https://www.linkedin.com/in/elsabeth-zeleke/",
    ),
    TeamMember(
      name: 'Samiya Y.',
      profilePhotoPath: AssetImage('asset/samiyaY.jpg'),
      bio:
          "I am 3rd year,software engineering student,full stack developer and flutter developer",
      email: "sammysamutii@gmail.com",
      linkedin: "https://www.linkedin.com/in/samiya-yusuf-a94b42296/",
    ),
    TeamMember(
      name: 'Samrawit',
      profilePhotoPath: AssetImage('asset/samri.jpg'),
      bio: "I am 3rd year, elecrtical engineering student, flutter developer",
      email: "samrawitsissayg.michael@gmail.com",
      linkedin:
          "https://www.linkedin.com/in/samrawit-sissay-646556294?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Card(
                  color: Color.fromARGB(255, 237, 241, 245),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Our Team',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 15.0,
                          ),
                          itemCount: teamMembers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showProfileDialog(
                                        context, teamMembers[index]);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        teamMembers[index].profilePhotoPath,
                                    radius: 30.0,
                                  ),
                                ),
                                // SizedBox(height: 2.0),

                                InkWell(
                                  onTap: () {
                                    _showProfileDialog(
                                        context, teamMembers[index]);
                                  },
                                  child: Text("${teamMembers[index].name}"),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'We are students from AASTU (Addis Ababa Science and Technology University) and proud members of GDSC (Google Developer Student Clubs). Our goal is to exchange skills among students and connect with recruiters to foster growth and opportunities in the tech community.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, TeamMember teamMember) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text("Profile")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: teamMember.profilePhotoPath,
                ),
              ),
              SizedBox(height: 10),
              Text(
                teamMember.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(teamMember.bio),
              Divider(),
              if (teamMember.linkedin.isNotEmpty)
                TextButton(
                  onPressed: () {
                    launch(teamMember.linkedin);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.link),
                      SizedBox(width: 10),
                      Text("Check my LinkedIn"),
                    ],
                  ),
                ),
              if (teamMember.email.isNotEmpty)
                TextButton(
                  onPressed: () {
                    launch('mailto:${teamMember.email}');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 10),
                      Text("Send Email"),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
