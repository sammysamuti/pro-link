import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  final String jobId;
  final String title;
  final String description;
  final String requirements;
  final String location;
  final String salaryRange;
  final String? imageUrl;

  const JobDetailPage({
    Key? key,
    required this.jobId,
    required this.title,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salaryRange,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Description: $description'),
            SizedBox(height: 8),
            Text('Requirements: $requirements'),
            SizedBox(height: 8),
            Text('Location: $location'),
            SizedBox(height: 8),
            Text('Salary Range: $salaryRange'),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the edit job page
                    // You can pass the job details to the edit page if needed
                  },
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Delete the job
                    // You may want to show a confirmation dialog before deleting
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
