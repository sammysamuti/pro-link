import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color.fromARGB(255, 247, 242, 242),
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
            ),
            Text("Profile"),
            Icon(
              Icons.search,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Column(children: [
              const CircleAvatar(
                radius: 50.0,
                backgroundImage:
                    AssetImage('skillswap\asset\profile_img.jpg'),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 18, 18),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Passionate Developer',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 22, 21, 21),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Skills and Interests:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 23, 22, 22),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color.fromARGB(255, 238, 234, 234)),
                icon: const Icon(
                  Icons.edit,
                ),
                label: const Text("Edit Profile"),
              ),
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Color.fromARGB(174, 252, 250, 250),
            child: const Row(
              children: [
                Icon(
                  Icons.settings,
                  size: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Settings",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Color.fromARGB(174, 252, 250, 250),
            child: const Row(
              children: [
                Icon(
                  Icons.mail,
                  size: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Contact",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Color.fromARGB(174, 252, 250, 250),
            child: const Row(
              children: [
                Icon(
                  Icons.add,
                  size: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Create Project",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: const Color.fromARGB(255, 40, 42, 43),
              minimumSize: const Size(400.0, 50.0),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(255, 230, 229, 227)),
            ),
          )
        ],
      ),
      //navigation
    );
  }
}
