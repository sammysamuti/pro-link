// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:skillswap/Project/userdata.dart';
// import 'package:skillswap/homepageCandidate/Search/projectsearch.dart';
// import 'package:skillswap/homepageCandidate/Search/search.dart';
// import 'package:skillswap/homepageCandidate/recentproject.dart';
// import 'package:skillswap/homepageCandidate/sidebar.dart';
// import 'package:skillswap/widgets/buttons.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final UserController userController = Get.find();
//   List _allProject = [];
//   List _Project = [];
//   bool _isLoading = false;
//   List _preference = [];

//   int fetchedCount = 0;
//   DocumentSnapshot? lastDocument;

//   fetchNextProject() async {
//     if (fetchedCount >= 10) {
//       // Stop fetching data once result list size reaches 10
//       return;
//     }

//     QuerySnapshot querySnapshot;

//     if (lastDocument == null) {
//       // Fetch the first batch of data
//       querySnapshot = await FirebaseFirestore.instance
//           .collection('Project')
//           .orderBy('TimeStamp', descending: true)
//           .limit(1)
//           .get();
//     } else {
//       // Fetch the next batch of data using pagination
//       querySnapshot = await FirebaseFirestore.instance
//           .collection('Project')
//           .orderBy('TimeStamp', descending: true)
//           .startAfterDocument(lastDocument!)
//           .limit(1)
//           .get();
//     }

//     if (querySnapshot.docs.isNotEmpty) {
//       var project = querySnapshot.docs[0];
//       List<String> skills = List<String>.from(project['SkillReq'] ?? []);
//       // print(skills);
//       // print("user");
//       // print(userController.userdata['Skills']);
//       List user = [];
//       for (var s in userController.userdata['Skills']) {
//         user.add(s['skill'].toLowerCase());
//       }
//       List<String> skillNames = [];
//       for (var skill in skills) {
//         skillNames.add(skill.toLowerCase());
//       }
//       if (user.any((skill) => skillNames.contains(skill.toLowerCase())) &&
//           !userController.userdata['MyProjects'].contains(project)) {
//         // Some action here
//         _preference.add(project);
//         fetchedCount++;
//       }

//       // Update lastDocument for pagination
//       lastDocument = querySnapshot.docs.last;
//       fetchNextProject();
//     }
//   }

//   allproject() async {
//     setState(() {
//       _isLoading = true;
//     });
//     var data = await FirebaseFirestore.instance
//         .collection('Project')
//         .orderBy('TimeStamp', descending: false)
//         .limit(10) // Limit to only fetch the top 10 projects
//         .get();
//     setState(() {
//       _allProject = data.docs;
//       // Remove unwanted elements from _allProject
//       _allProject.removeWhere(
//           (doc) => userController.userdata['MyProjects'].contains(doc.id));
//       _Project = List.from(_allProject);
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     fetchNextProject();
//     // allproject();
//     super.initState();
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Scaffold.of(context).openDrawer();
//                     },
//                     child: CachedNetworkImage(
//                       imageUrl: userController.userdata['profilePic'],
//                       imageBuilder: (context, imageProvider) => Container(
//                         width: 50.0,
//                         height: 50.0,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                               image: imageProvider, fit: BoxFit.cover),
//                         ),
//                       ),
//                       placeholder: (context, url) => Icon(Icons.person),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Search_Screen()));
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(8),
//                         height: height * 0.06,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.search,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(
//                               width: width * 0.01,
//                             ),
//                             Text(
//                               'Search Users and Projects',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20.0),
//               Container(
//                 height: height,
//                 child: ListView.builder(
//                   itemCount: _preference.length,
//                   itemBuilder: (context, index) {
//                     Map<String, dynamic>? projectdata =
//                         _preference[index].data() as Map<String, dynamic>?;
//                     if (projectdata!['ProjectTitle'] == null) {
//                       // Show a loading indicator
//                       if (_isLoading == true) {
//                         return Container();
//                       } else {
//                         _isLoading = true;
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                     }
//                     return Column(
//                       children: [ProjectSearch(projectdata), Divider()],
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
