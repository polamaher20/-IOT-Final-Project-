import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class Admin extends StatefulWidget {
  final String userId1;
  final String email1;

  Admin({required this.userId1, required this.email1});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 98, 106, 222), // Lighter background color
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 73, 82, 216), // App bar color
        title: Center(
          child: Text(
            'User Detail',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding to the body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
            children: [
              CircleAvatar(
                radius: 75.0,
                backgroundImage: AssetImage('images/castro1.jpg'),
                backgroundColor: Colors.grey[300], // Background color
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.amber[700], size: 30), // Edit icon
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between profile and divider
              Divider(
                color: const Color.fromARGB(255, 222, 232, 233),
                thickness: 1.5, // Thicker divider
              ),
              SizedBox(height: 20), // Space between divider and content
              _buildDetailCard(
                title: 'User ID',
                icon: Icons.person_sharp,
                content: widget.userId1,
              ),
              SizedBox(height: 20), // Space between cards
              _buildDetailCard(
                title: 'Your Email',
                icon: Icons.email_sharp,
                content: widget.email1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Card(
      elevation: 5, // Add shadow to the card
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(
                icon,
                color: Colors.blue,
              ),
              title: Text(
                content,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
