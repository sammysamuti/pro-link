import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:skillswap/Datas/projectcontroller.dart';
import 'package:skillswap/Datas/userdata.dart';
import 'package:skillswap/firebase/firebase.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/project.dart';

class MyProjects extends StatefulWidget {
  MyProjects({super.key});

  @override
  State<MyProjects> createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  final UserController usercontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    final ProjectController projectController = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("My Projects"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                child: CircularProgressIndicator()); // Or any loading indicator
          }

          List<Project> projectlist = [];
          final projects = snapshot.data!.docs.toList();
          for (var pro in projects) {
            final projectId = pro.id;
            if (usercontroller.userdata['MyProjects'].contains(projectId)) {
              Map<String, dynamic> projectData =
                  pro.data() as Map<String, dynamic>;
              final oneProject = Project(projectData, projectId);
              projectlist.add(oneProject);
            }
          }
          if (projectlist.length == 0) {
            return Center(child: Text("No Project"));
          } else {
            return ListView(
              children: projectlist,
            );
          }
        },
      ),
    );
  }
}
