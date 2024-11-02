import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/editor.dart';
import 'package:skillswap/homepageCandidate/Search/projectsearch.dart';
import 'package:skillswap/homepageCandidate/Search/search.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:skillswap/homepageCandidate/Search/search2.dart';
import 'package:skillswap/homepageCandidate/home/Job/post.dart';
import 'package:skillswap/widgets/buttons.dart';

List<String> items = [
  "Add",
  'Flutter',
  'Node.js',
  'React Native',
  'Java',
  'Docker',
  'MySQL',
  "UI/UX",
  "Django",
  "React",
  "Machine Learning",
  "Artificial Intelligence",
  "Competitive Programming",
  "Project Management",
];

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.find();
  List _allProject = [];
  List _Project = [];
  bool _isLoading = false;
  int fetchedCount = 0;
  DocumentSnapshot? lastDocument;
  List<String> selectedItems = [];
  TextEditingController skillController = TextEditingController();

  allproject() async {
    setState(() {
      _isLoading = true;
    });
    var data = await FirebaseFirestore.instance
        .collection('Project')
        .orderBy('TimeStamp', descending: true)
        .get();
    setState(() {
      _allProject = data.docs;
      // Remove unwanted elements from _allProject
      _allProject.removeWhere(
          (doc) => userController.userdata['MyProjects'].contains(doc.id));
      _Project = List.from(_allProject);
      _isLoading = false;
    });
  }

  searchResult() {
    var showResult = [];
    List<String> filter = [];
    for (var skill in selectedItems) {
      filter.add(skill.toLowerCase());
    }

    if (filter.length != 0) {
      for (var project in _allProject) {
        List<String> skills = List<String>.from(project['SkillReq'] ?? []);
        List<String> skillNames = [];

        for (var skill in skills) {
          skillNames.add(skill.toLowerCase());
        }

        if (filter.every((skill) => skillNames.contains(skill.toLowerCase()))) {
          showResult.add(project);
        }
      }
    } else {
      // Reset search result based on current search mode
      showResult = List.from(_allProject);
    }
    setState(() {
      _Project = showResult;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    allproject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        CupertinoIcons.text_justify,
                        size: 30,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search_Screen()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              'Search Users and Projects',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                ],
              ),
            ),
            // SizedBox(
            //   height: height * 0.07,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: items.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       final item = items[index];
            //       final isSelected = selectedItems.contains(item);
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             if (isSelected) {
            //               selectedItems.remove(item);
            //             } else {
            //               selectedItems.add(item);
            //             }
            //             // searchResult();
            //           });
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Container(
            //             width: width * 0.2 + item.length * 3,
            //             height: height * 0.03,
            //             padding: EdgeInsets.all(5),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(20),
            //               border: Border.all(
            //                 color: isSelected
            //                     ? Color(0XFF2E307A)
            //                     : Colors.transparent,
            //               ),
            //               color: isSelected
            //                   ? Color(0XFF2E307A)
            //                   : Color.fromARGB(255, 237, 241, 245),
            //             ),
            //             child: Center(
            //               child: Text(
            //                 item,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: TextStyle(
            //                   color: isSelected ? Colors.white : Colors.black,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // Expanded(
            //   child: _Project.isEmpty
            //           ? Center(
            //               child: Text("No results found"),
            //             )
            //           : ListView.builder(
            //               itemCount: _Project.length,
            //               itemBuilder: (context, index) {
            //                   Map<String, dynamic> projectdata =
            //                       _Project[index].data()
            //                           as Map<String, dynamic>;
            //                   if (projectdata['ProjectTitle'] == null) {
            //                     // Show a loading indicator
            //                     if (_isLoading == true) {
            //                       return Container();
            //                     } else {
            //                       _isLoading = true;
            //                       return Center(
            //                         child: CircularProgressIndicator(),
            //                       );
            //                     }
            //                   }
            //                   return Column(
            //                     children: [
            //                       ProjectSearch(projectdata,_Project[index].id),
            //                       Divider()
            //                     ],
            //                   );

            //               },
            //             ),
            // ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Project')
                    .orderBy('TimeStamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Or any loading indicator
                  }
                  List<String> filter = [];
                  for (var skill in selectedItems) {
                    filter.add(skill.toLowerCase());
                  }
                  List<Widget> projectlist = [];
                  final projects = snapshot.data!.docs.toList();
                  for (var pro in projects) {
                    Map<String, dynamic> projectData =
                        pro.data() as Map<String, dynamic>;
                    final projectId = pro.id;
                    List<String> skills =
                        List<String>.from(projectData['SkillReq'] ?? []);
                    List<String> skillNames = [];

                    for (var skill in skills) {
                      skillNames.add(skill.toLowerCase());
                    }

                    if (filter.every((skill) =>
                            skillNames.contains(skill.toLowerCase())) &&
                        !userController.userdata['MyProjects']
                            .contains(projectId) &&
                        !userController.userdata['WorkingOnPro']
                            .contains(projectId)) {
                      final oneProject = ProjectSearch(projectData, projectId);
                      projectlist.add(oneProject);
                    }
                  }

                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverFixedExtentList(
                        itemExtent: height * 0.25,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Jobs();
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        pinned: true,
                        expandedHeight: height * 0.1,
                          title: SizedBox(
                            height: height * 0.07,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = items[index];
                                final isSelected = selectedItems.contains(item);
                                if (index == 0) {
                                  return GestureDetector(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: Text('Preference'),
                                            content: StatefulBuilder(
                                                builder: (context, setState) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomTextFormField(
                                                    width: width,
                                                    height: height * 0.07,
                                                    hintText: 'Skill',
                                                    controller: skillController,
                                                  ),
                                                ],
                                              );
                                            }),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  if (!skillController
                                                      .text.isEmpty) {
                                                   items.insert(1, skillController.text);
                                                    setState(() {
                                                    });
                                                    skillController.text = '';
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    ,child: Icon(Icons.add,size: 30,));
                                }
                                return GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      items.remove(item);
                                    });
                                  },
                                  onTap: () {
                                    
                                    setState(() {
                                      if (isSelected) {
                                        selectedItems.remove(item);
                                      } else {
                                        selectedItems.add(item);
                                      }
                                      // searchResult();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: width * 0.2 + item.length * 3,
                                      height: height * 0.03,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? Color(0XFF2E307A)
                                              : Colors.transparent,
                                        ),
                                        color: isSelected
                                            ? Color(0XFF2E307A)
                                            : Color.fromARGB(255, 237, 241, 245),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                        ),
                      SliverFixedExtentList(
                        itemExtent: height * 0.45,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return projectlist[index];
                          },
                          childCount: projectlist.length,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
