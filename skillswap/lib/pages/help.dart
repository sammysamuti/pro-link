import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<HelpItem> _helpItems = [
    HelpItem(
        title: 'Using the App',
        description: 'Learn about the app\'s features and functionalities.'),
    HelpItem(
        title: 'Account Management',
        description: 'Manage your profile, settings, and preferences.'),
    HelpItem(
        title: 'Troubleshooting',
        description: 'Find solutions to common issues.'),
    HelpItem(
        title: 'Contact Us',
        description: 'Get in touch with our support team.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _helpItems.length,
        itemBuilder: (context, index) {
          final helpItem = _helpItems[index];
          return ExpansionTile(
            title: Text(helpItem.title, style: TextStyle(color: Colors.black)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(helpItem.description),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HelpItem {
  final String title;
  final String description;

  HelpItem({required this.title, required this.description});
}