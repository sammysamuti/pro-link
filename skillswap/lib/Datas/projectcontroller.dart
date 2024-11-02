import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:skillswap/firebase/firebase.dart';
import 'package:intl/intl.dart';

class ProjectController extends GetxController {
  final CollectionReference dbrefproject =
      FirebaseFirestore.instance.collection('Project');
  final CollectionReference completedref =
      FirebaseFirestore.instance.collection('CompletedProjects');
  var _Projects = <Map<String, dynamic>>[].obs;

  // ProjectController(List<dynamic> projectids) {
  //   _initializeProjects(projectids);
  // }
  // ProjectController.empty() {}

  Future<void> initializeProjects(List<dynamic>? projectids) async {
    if (projectids != null) {
      for (var p in projectids) {
        final projectData = await ProjectData(p);
        _Projects.add(projectData);
      }
    }
  }

  Future<Map<String, dynamic>> ProjectData(String docid) async {
    try {
      DocumentSnapshot snapshot = await dbrefproject.doc(docid).get();
      if (snapshot.exists) {
        Map<String, dynamic> projectdata =
            snapshot.data() as Map<String, dynamic>;
        return projectdata;
      } else {
        return {}; // Return empty map if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return {}; // Return empty map if there's an error
    }
  }

  

  void addProject(
      String projectimg,
      String projectTitle,
      String projectDescription,
      String userid,
      List<String> skillReq,
      List<String> teams) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    Map<String, dynamic> project = {
      'Projectimg': projectimg,
      'ProjectTitle': projectTitle,
      'ProjectDes': projectDescription,
      'Owner': userid,
      'SkillReq': skillReq,
      'Teams': teams,
      'TimeStamp': formattedDate
    };
    _Projects.add(project);
  }

  void clearProjects() {
    _Projects.clear();
  }

  get Project => _Projects;
}
