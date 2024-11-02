import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final List<PrivacyPolicyItem> _policyItems = [
    PrivacyPolicyItem(
      title: 'Data Collection',
      description: 'What information we collect and how we use it.',
    ),
    PrivacyPolicyItem(
      title: 'Sharing Information',
      description: 'When and with whom we share your information.',
    ),
    PrivacyPolicyItem(
      title: 'Your Choices',
      description: 'Your control over your information and privacy settings.',
    ),
    PrivacyPolicyItem(
      title: 'Security',
      description: 'How we protect your information.',
    ),
    PrivacyPolicyItem(
      title: 'Contact Us',
      description: 'How to reach us regarding privacy concerns.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _policyItems.length,
        itemBuilder: (context, index) {
          final policyItem = _policyItems[index];
          return ExpansionTile(
            title:
                Text(policyItem.title, style: TextStyle(color: Colors.black)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(policyItem.description),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PrivacyPolicyItem {
  final String title;
  final String description;

  PrivacyPolicyItem({required this.title, required this.description});
}