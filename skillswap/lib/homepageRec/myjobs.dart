import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:skillswap/homepageRec/edit.dart';
import 'package:skillswap/homepageRec/postjobform.dart';

class RecruiterJobs extends StatefulWidget {
  const RecruiterJobs({Key? key});

  @override
  State<RecruiterJobs> createState() => _RecruiterJobsState();
}

class _RecruiterJobsState extends State<RecruiterJobs> {
  late final String userId;
  TextEditingController searchController =
      TextEditingController(); // Add TextEditingController
  bool _isSearching = false; // Add _isSearching variable
  late String searchQuery = ''; // Add searchQuery variable

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search job name...',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        _isSearching = false;
                        searchQuery = '';
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.blue,
              )
            : Text("Recruiter Jobs"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('JobPosts')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No jobs found.');
            }
            // Filter the list based on searchQuery
            final filteredDocs = snapshot.data!.docs.where((document) {
              final title = (document.data() as Map)['title'] ?? '';
              return title.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            // If no search query or not searching, use all documents
            final documentsToShow = _isSearching && searchQuery.isNotEmpty
                ? filteredDocs
                : snapshot.data!.docs;

            return ListView(
              children: documentsToShow.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                print("data");
                print(data);
                print(data['requirements']);
                return DataContainer(
                  documentId: document.id,
                  projectTitle: data['title'],
                  companyName: data['companyName'],
                  description: data['description'],
                  location: data['location'],
                  postedDate: _formatTimestamp(data['timestamp']),
                  imageUrl: data['imageUrl'],
                  requirements: data['requirements'],
                  salaryRange: data['salaryRange'],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}

class DataContainer extends StatelessWidget {
  final String documentId;
  final String projectTitle;
  final String companyName;
  final String description;
  final String location;
  final String postedDate;
  final String imageUrl;
  final List<dynamic> requirements;
  final String salaryRange;

  DataContainer({
    required this.documentId,
    required this.projectTitle,
    required this.companyName,
    required this.description,
    required this.location,
    required this.postedDate,
    required this.imageUrl,
    required this.requirements,
    required this.salaryRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 237, 237),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            projectTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Company: $companyName'),
          SizedBox(height: 8),
          Text('Location: $location'),
          SizedBox(height: 8),
          Text('Posted: $postedDate'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostJobFormEdit(
                        initialId: documentId,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteJob(context, documentId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteJob(BuildContext context, String documentId) {
    print("Deleting document with ID: $documentId");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this job?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('JobPosts')
                    .doc(documentId)
                    .delete()
                    .then((value) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("Job deleted successfully"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }).catchError((error) {
                  print("Error deleting job: $error");
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Failed to delete job: $error"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                });
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
