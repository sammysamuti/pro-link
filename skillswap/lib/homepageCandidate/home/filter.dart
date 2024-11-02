// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';

// class Filter extends StatefulWidget {
//   @override
//   _FilterState createState() => _FilterState();
// }

// class _FilterState extends State<Filter> {
//   List<String> items = [
//     'Flutter',
//     'Node.js',
//     'React Native',
//     'Java',
//     'Docker',
//     'MySQL',
//     "UI/UX",
//     "Django",
//     "React",
//     "Machine Learning",
//     "Artificial Intelligence",
//     "Competitive Programming",
//     "Project Management",
//   ];

//   List<String> selectedItems = [];

//   @override
//   Widget build(BuildContext context) {
//      double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(title: Text('Filter')),
//       body: Container(
//         height: height*0.07,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: items.length,
//           itemBuilder: (BuildContext context, int index) {
//             final item = items[index];
//             final isSelected = selectedItems.contains(item);
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isSelected) {
//                     selectedItems.remove(item);
//                   } else {
//                     selectedItems.add(item);
//                   }
//                   print(selectedItems);
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width:width*0.2 + item.length*3 ,
//                   height: height*0.03,
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: isSelected ? Color(0XFF2E307A) : Colors.transparent,
//                     ),
//                     color: isSelected ? Color(0XFF2E307A) : Color.fromARGB(255, 237, 241, 245),
//                   ),
//                   child: Center(
//                     child: Text(
//                       item,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
