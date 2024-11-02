import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final CollectionReference dbrefuser =
      FirebaseFirestore.instance.collection('Users');
  
  final CollectionReference dbrefREC =
      FirebaseFirestore.instance.collection('Recruiter');

  var _user = RxMap<String, dynamic>();
  var _LoadingUserData = true.obs;
  var _userid;

  

  // UserController(String userid) {
    
  //   _LoadingUserData.value = true;
  //   initializeuser(userid).then((_) {
  //     _LoadingUserData.value = false;
  //   });
  // }

  // Future<void> initializeuser(String userid) async {
  //   _user = await userData(userid);
  //   _userid = userid;
  // }

Future<void> initializeuser(String userid) async {
  try {
    _user = await userData(userid);
    _userid = userid;
  } catch (e) {
    print("Error initializing user: $e");
    // Handle error (e.g., set _LoadingUserData to false or show error message)
  }
}

Future<RxMap<String, dynamic>> userData(String docid) async {
    try {
      DocumentSnapshot snapshot = await dbrefuser.doc(docid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        RxMap<String, dynamic> userdata = RxMap<String, dynamic>.from(userData);
        return userdata;
      } else {
        return RxMap<String,
            dynamic>(); // Return empty map if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return RxMap<String, dynamic>(); // Return empty map if there's an error
    }
  }

  Stream<DocumentSnapshot<Object?>> getuserdata(String userid) {
     return dbrefuser
         .doc(userid)
         .snapshots();
   }

  Future<Map<String, dynamic>> userData2(String docid) async {
    try {
     DocumentSnapshot snapshot = await dbrefuser.doc(docid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userdata =
            snapshot.data() as Map<String, dynamic>;
        return userdata;
      } else {
        return {}; // Return empty map if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return {}; // Return empty map if there's an error
    }
  }

Future<void> initializeRec(String userid) async {
  try {
    _user = await userRec(userid);
    _userid = userid;
  } catch (e) {
    print("Error initializing user: $e");
    // Handle error (e.g., set _LoadingUserData to false or show error message)
  }
}




  Future<RxMap<String, dynamic>> userRec(String docid) async {
    try {
      DocumentSnapshot snapshot = await dbrefREC.doc(docid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        RxMap<String, dynamic> userdata = RxMap<String, dynamic>.from(userData);
        return userdata;
      } else {
        return RxMap<String,
            dynamic>(); // Return empty map if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return RxMap<String, dynamic>(); // Return empty map if there's an error
    }
  }


  Future<List<Map<String, dynamic>>> fetchUsersWithMatchingSkills(
      String recruiterEmail) async {
    List<Map<String, dynamic>> usersWithMatchingSkills = [];
    Set<String> uniqueUserIds = Set<String>();

    try {
      // Fetch recruiter document
      QuerySnapshot recruiterSnapshot =
          await dbrefREC.where('Email', isEqualTo: recruiterEmail).get();

      // Check if there are any documents in the snapshot
      if (recruiterSnapshot.docs.isEmpty) {
        return usersWithMatchingSkills;
      }

      // Get recruiter's skills
      final firstDocData =
          recruiterSnapshot.docs[0].data() as Map<String, dynamic>?;
      if (firstDocData == null || !firstDocData.containsKey('Skills')) {
        return usersWithMatchingSkills;
      }

      List<dynamic> recruiterSkills = firstDocData['Skills'];

      // Query users collection for users with similar skills
      QuerySnapshot usersSnapshot = await dbrefuser.get();
      usersSnapshot.docs.forEach((userDoc) {
        Map<String, dynamic> userData = userDoc.data()
            as Map<String, dynamic>; // Cast to Map<String, dynamic>

        // Add 'uid' field to userData
        userData['uid'] = userDoc.id;

        if (userData.containsKey('Skills') && userData['Skills'].isNotEmpty) {
          // Check if user has at least one skill similar to the recruiter
          List<dynamic> userSkills = userData['Skills'];
          userSkills.forEach((userSkill) {
            recruiterSkills.forEach((recruiterSkill) {
              if (userSkill['skill'] == recruiterSkill['skill'] &&
                  !uniqueUserIds.contains(userData['uid'])) {
                usersWithMatchingSkills.add(userData);
                uniqueUserIds.add(userData['uid']);
              }
            });
          });
        }
      });

      return usersWithMatchingSkills;
    } catch (error) {
      print('Error fetching users with matching skills: $error');
      return usersWithMatchingSkills;
    }
  }

  void clear() {
    _user.clear();
    _userid = '';
  }

  get loading => _LoadingUserData;
  get userid => _userid;
  get userdata => _user;
}
