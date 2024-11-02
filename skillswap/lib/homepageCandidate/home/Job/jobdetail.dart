import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/homepageCandidate/home/Job/application.dart';
import 'package:skillswap/widgets/buttons.dart';

class JobDetail extends StatefulWidget {
  final Map<String, dynamic> jobdata;
  const JobDetail(this.jobdata, {super.key});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  List<bool> _isSelected = [true, false]; // Track button selection

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
      _pageController.jumpToPage(index);

      // Update button selection
      _isSelected = List.generate(_isSelected.length, (i) => i == index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text(widget.jobdata['title']),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: widget.jobdata['imageUrl'],
              imageBuilder: (context, imageProvider) => Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(widget.jobdata['companyName']),
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonOne(
                  "Description",
                  _isSelected[0] ? Colors.white : Color(0XFF2E307A),
                  _isSelected[0] ? Color(0XFF2E307A) : Colors.white,
                  width * 0.4,
                  height * 0.05,
                  14, () {
                _onItemTapped(0);
              }),
              SizedBox(
                width: width * 0.02,
              ),
              ButtonOne(
                  "Requirement",
                  _isSelected[1] ? Colors.white : Color(0XFF2E307A),
                  _isSelected[1] ? Color(0XFF2E307A) : Colors.white,
                  width * 0.4,
                  height * 0.05,
                  14, () {
                _onItemTapped(1);
              }),
            ],
          ),
          SizedBox(
            height: height * 0.45,
            width: width*0.8,
            child: Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                    _isSelected =
                        List.generate(_isSelected.length, (i) => i == index);
                  });
                },
                children: [
                  SizedBox(width: width*0.8,child: buildDescription()),
                  buildRequirement(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.07,
          ),
          ButtonOne("Apply Now", Colors.white, Color(0XFF2E307A), width * 0.8,
              height * 0.07, 16, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JobApplication(widget.jobdata)));
          })
        ],
      ),
    );
  }

  Widget buildDescription() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        // height:MediaQuery.of(context).size.height*0.6 ,
        child: Center(
            child: ListView(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor:
                        Colors.black, // Customize bullet color here
                    radius: 4, // Adjust bullet size as needed
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  const Text(
                    "Location : ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                
                  Text(
                    "${widget.jobdata['location']}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor:
                        Colors.black, // Customize bullet color here
                    radius: 4, // Adjust bullet size as needed
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  const Text(
                    "Salary : ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  Text(
                    "${widget.jobdata['salaryRange']}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
              width: width*0.8,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "${widget.jobdata['description']}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  softWrap: true,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget buildRequirement() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(widget.jobdata['requirements']);
    return Expanded(
      child: Container(
        //  height:MediaQuery.of(context).size.height*0.6 ,
        child: Center(
            child: ListView.builder(
                itemCount: widget.jobdata['requirements'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 20),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor:
                              Colors.black, // Customize bullet color here
                          radius: 4, // Adjust bullet size as needed
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                       Text("${widget.jobdata['requirements'][index]['name']}",softWrap: true,style: TextStyle(
                      fontSize: 15,
                    ),),
                       SizedBox(
                          width: width * 0.05,
                        ),
                        Text("${widget.jobdata['requirements'][index]['level']}",softWrap: true,style: TextStyle(
                      fontSize: 15,
                    ),),
                      ],
                    ),
                  );
                  
                })),
      ),
    );
  }
}
