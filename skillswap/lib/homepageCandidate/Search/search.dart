import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/firebase/firebase.dart';
import 'package:skillswap/homepageCandidate/Search/projectsearch.dart';
import 'package:skillswap/homepageCandidate/Search/usersearch.dart';

class Search_Screen extends StatefulWidget {
  Search_Screen({super.key});

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  final TextEditingController _search = TextEditingController();
  late final Firebase_Service _auth;
  final FocusNode _searchFocusNode = FocusNode();
  final UserController userController = Get.find();

  bool _searchInProjects = false;
  List _allUser = [];
  List _allProject = [];
  List _searchResult = [];
  bool _isLoading = false;

  allUser() {
    setState(() {
      _isLoading = true; 
    });
    FirebaseFirestore.instance
        .collection('Users')
        .orderBy('First')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        _allUser = snapshot.docs;
        _allUser.removeWhere((doc) => doc.id == userController.userid);
        searchResult(); // Move this inside setState
      });
     
    });
  }

  allProject() {
    setState(() {
      _isLoading = true; // Set isLoading to true before performing search
    });
    FirebaseFirestore.instance
        .collection('Project')
        .orderBy('TimeStamp')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        _allProject = snapshot.docs;
        // Remove unwanted elements from _allProject
        _allProject.removeWhere(
            (doc) => userController.userdata['MyProjects'].contains(doc.id));
        _allProject.removeWhere(
            (doc) => userController.userdata['WorkingOnPro'].contains(doc.id));
        searchResult(); // Move this inside setState
      });
    });
  }

  searchResult() {
    setState(() {
      _isLoading = true; // Set isLoading to true before performing search
    });
    var showResult = [];
    if (_search.text.isNotEmpty) {
      List<String> searchthis = _search.text
          .split(" ")
          .where((word) => word.isNotEmpty)
          .map((word) => word.trim())
          .toList();

      if (_searchInProjects == false) {
        // Search in users
        for (var u in _allUser) {
          List<Map<String, dynamic>> skills =
              List<Map<String, dynamic>>.from(u['Skills'] ?? []);
          List<String> skillNames = [];

          for (var skill in skills) {
            skillNames.add(skill['skill'].toLowerCase());
          }

          if (searchthis
              .every((skill) => skillNames.contains(skill.toLowerCase()))) {
            showResult.add(u);
            break;
          }
        }
      }
      // search one by one skill

      // for (var skill in skills) {
      //   if (skill['skill']
      //       .toLowerCase()
      //       .contains(_search.text.toLowerCase())) {
      //     showResult.add(u);
      //     break;
      //   }
      // }

      else {
        // Search in projects
        for (var project in _allProject) {
          var name = project['ProjectTitle'].toString().toLowerCase();

          // List<String> skills = List<String>.from(project['SkillReq'] ?? []);

          // search one by one skill

          // for (var skill in skills) {
          //   if (skill.toLowerCase().contains(_search.text.toLowerCase())) {
          //     showResult.add(project);
          //   }
          // }
          // List<String> skillNames = [];

          // for (var skill in skills) {
          //   skillNames.add(skill.toLowerCase());
          // }

          // if (searchthis
          //     .every((skill) => skillNames.contains(skill.toLowerCase()))) {
          //   showResult.add(project);
          // }

          if (name.contains(_search.text.toLowerCase())) {
            showResult.add(project);
          }
        }
      }
    } else {
      // Reset search result based on current search mode
      showResult =
          _searchInProjects ? List.from(_allProject) : List.from(_allUser);
    }
    setState(() {
      _searchResult = showResult;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearch);
    _searchFocusNode.requestFocus();
    allUser();
    _auth = Firebase_Service(context);
  }

  _onSearch() {
    if (_search.text.isNotEmpty && _search.text.trim() != "") {
      searchResult();
    }
  }

  @override
  void dispose() {
    _search.removeListener(_onSearch);
    _search.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          height: height * 0.06,
          child: CupertinoSearchTextField(
              controller: _search, focusNode: _searchFocusNode),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _searchInProjects = false;
                      });
                      allUser();
                    },
                    child: Text(
                      "Users",
                      style: TextStyle(
                        color: _searchInProjects
                            ? Colors.black
                            : Color(0XFF2E307A),
                        fontWeight: _searchInProjects
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _searchInProjects = true;
                      });
                      allProject();
                    },
                    child: Text(
                      "Projects",
                      style: TextStyle(
                        color: _searchInProjects
                            ? Color(0XFF2E307A)
                            : Colors.black,
                        fontWeight: _searchInProjects
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _searchResult.isEmpty
                      ? Center(
                          child: Text("No results found"),
                        )
                      : ListView.builder(
                          itemCount: _searchResult.length,
                          itemBuilder: (context, index) {
                            if (_searchInProjects == false) {
                              Map<String, dynamic> userdata =
                                  _searchResult[index].data()
                                      as Map<String, dynamic>;
                              String userid = _searchResult[index].id;
                              // Check if userdata is null
                              if (userdata['First'] == null) {
                                // Show a loading indicator
                                if (_isLoading == true) {
                                  return Container();
                                } else {
                                  _isLoading = true;
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }
                              return Column(
                                children: [
                                  UserSearch(userdata, userid),
                                  Divider()
                                ],
                              );
                            } else {
                              Map<String, dynamic> projectdata =
                                  _searchResult[index].data()
                                      as Map<String, dynamic>;
                              if (projectdata['ProjectTitle'] == null) {
                                // Show a loading indicator
                                if (_isLoading == true) {
                                  return Container();
                                } else {
                                  _isLoading = true;
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }
                              return Column(
                                children: [
                                  ProjectSearch(
                                      projectdata, _searchResult[index].id),
                                  Divider()
                                ],
                              );
                            }
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
