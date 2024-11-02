import 'package:flutter/material.dart';

class UpdateProjectPage extends StatelessWidget {
  const UpdateProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Project'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://edukitapp.com/img/blog/blog-23.jpg'),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Project Title',
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 10,
                  //  color: Colors.grey[200],
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                //  const SizedBox(height: 16),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                  ),
                  Container(
                    height: 2,
                    color: Colors.black,
                  ), 
                  const SizedBox(height: 16),
                  const Text(
                    'Project Duration',
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 10,
                 //   color: Colors.grey[200],
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                 //  const SizedBox(height: 8),
                  Container(
                    height: 10,
                  ),
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Project Description',
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      //color: const Color.fromARGB(255, 244, 231, 231),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: TextFormField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 380,
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('Save Changes', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }
}



