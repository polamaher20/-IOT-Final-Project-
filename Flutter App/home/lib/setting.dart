import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 132, 130, 130),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(
                context,
                text: 'Logout',
                icon: Icons.logout,
                color: Colors.redAccent,
                onPressed: () => _showLogoutDialog(context),
              ),
              SizedBox(height: 20),
              _buildButton(
                context,
                text: 'Go to Admin Website',
                icon: Icons.admin_panel_settings,
                color: Colors.blue,
                onPressed: () async {
                  final Uri _url = Uri.parse(
                      'http://192.168.100.5:8080/demo/admin/insert.php');
                  if (await canLaunchUrl(_url)) {
                    await launchUrl(_url);
                  } else {
                    throw 'Could not launch $_url';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((_) {
                  // Navigate to the login page after signing out
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                }).catchError((error) {
                  // Handle errors here if sign-out fails
                  print("Error signing out: $error");
                });
              },
            ),
          ],
        );
      },
    );
  }
}
