import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/homepageCandidate/ProjectPer/project_detail.dart';

class Project extends StatelessWidget {
  Map<String, dynamic> projectdata;
  String projectid;
  Project(this.projectdata, this.projectid,{super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProjectDetailPage(projectid: projectid,)));
        },
        child: Container(
          width: width,
          height: height * 0.4,
          decoration: BoxDecoration(
              // color: Color.fromARGB(255, 237, 241, 245),
              // borderRadius: BorderRadius.circular(10),
              // boxShadow: [
              //   BoxShadow(
              //     color:
              //         Colors.grey.withOpacity(0.5), // Shadow color (with opacity)
              //     spreadRadius: 1, // Extends the shadow beyond the box
              //     blurRadius: 1, // Blurs the edges of the shadow
              //     offset: Offset(0, 1), // Shifts the shadow (x, y)
              //   ),
              // ],
              ),
          child: Column(
            children: [
              // ClipRRect(
              //   borderRadius: const BorderRadius.only(
              //     topLeft: Radius.circular(10.0),
              //     topRight: Radius.circular(10.0),
              //     bottomLeft: Radius.circular(0.0),
              //     bottomRight: Radius.circular(0.0),
              //   ),
              //   child: Image.network(
              //       height: height * 0.3,
              //       width: width,
              //       fit: BoxFit.cover,
              //       projectdata['Projectimg']),
              // ),
              CachedNetworkImage(
                imageUrl: projectdata['Projectimg'],
                imageBuilder: (context, imageProvider) => Container(
                  height: height * 0.28,
                  width: width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                // placeholder: (context, url) =>CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            '${projectdata['ProjectTitle']}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            '${projectdata['ProjectDes']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
