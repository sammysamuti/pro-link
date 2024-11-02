import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/homepageCandidate/home/Job/jobdetail.dart';

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  State<Jobs> createState() => _UpdatesState();
}

class _UpdatesState extends State<Jobs> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data for each page
  final List<dynamic> pagesData = [];

  Future<void> allJobs() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('JobPosts')
        .limit(4)
        .get(); // Use get() instead of snapshots() to get a single snapshot

    setState(() {
      final List<DocumentSnapshot> jobs =
          snapshot.docs; // Extract the documents from the snapshot
      // Clear existing data in pagesData
      pagesData.clear();
      // Add fetched job data to pagesData
      for (var job in jobs) {
        Map<String, dynamic> jobData = job.data() as Map<String, dynamic>;

        jobData['JOB'] = job.id;
        pagesData.add(jobData);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allJobs();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: height * 0.2,
          width: width * 0.9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pagesData.length, // Number of items in the PageView
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  // print(pagesData[index].runtimeType);
                  //print(pagesData[index]);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobDetail(pagesData[index])));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0XFF2E307A),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        Text(
                          pagesData[index]['companyName'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          pagesData[index]['title'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                       
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text("See details",style: TextStyle(color: Colors.white),)),
                         ),
                        // Text(pagesData[index]['requirements'],
                        //     style: const TextStyle(
                        //         color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pagesData.length, // Number of pages
            (index) => Container(
              margin: const EdgeInsets.all(4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0XFF6055D8)
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
