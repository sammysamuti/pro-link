import 'package:flutter/material.dart';

class NewSkill extends StatefulWidget {
  NewSkill({Key? key}) : super(key: key);

  @override
  _NewSkillState createState() => _NewSkillState();
}

class _NewSkillState extends State<NewSkill> {
  final TextEditingController newskill = TextEditingController();
  String level = "Beginner";
  

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('New Skill'),
                content: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: newskill,
                      ),
                      ListTile(
                              title: Text('Beginner'),
                              // Define value property within ListTile
                              leading: Radio(
                                value: 'Beginner',
                                groupValue:
                                    level, // Group for radio buttons
                                onChanged: (value) => setState(
                                    () => level = value as String),
                              ),
                            ),
                            ListTile(
                              title: Text('Intermediate'),
                              // Define value property within ListTile
                              leading: Radio(
                                value: 'Intermediate',
                                groupValue: level,
                                onChanged: (value) => setState(
                                    () => level = value as String),
                              ),
                            ),
                            ListTile(
                              title: Text('Advanced'),
                              // Define value property within ListTile
                              leading: Radio(
                                value: 'Advanced',
                                groupValue: level,
                                onChanged: (value) => setState(
                                    () => level = value as String),
                              ),
                            ),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () {
                      print(newskill.text);
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        icon: Icon(
          Icons.add_circle_outline_outlined,
          color: Colors.red,
          size: 30,
        ));
  }
}
