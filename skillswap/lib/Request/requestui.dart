import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendRequest extends StatelessWidget {
  const SendRequest({super.key});

  @override
  Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Container(
        width: width*0.8,
        height: height*0.14,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                color: Color.fromARGB(255, 237, 241, 245),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             CachedNetworkImage(
                  imageUrl: "",
                  imageBuilder: (context, imageProvider) => Container(
                    height: height * 0.28,
                    width: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Icon(CupertinoIcons.person),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                            Text(
                              'John Doe',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  CupertinoIcons.clear_circled,size: 45,color: Colors.red,
                                  ),
                                SizedBox(width: 8.0),
                                Icon(
                                  CupertinoIcons.check_mark_circled,size: 45,color: Colors.green,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Can we collaborate on web design?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            
                          ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
    );

  }
}
