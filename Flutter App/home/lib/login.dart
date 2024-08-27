import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffB81736), Color(0xff281537)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    _icon(),
                    SizedBox(height: 50),
                    _inputField("Email", emailController,
                        iconData: Icons.email),
                    SizedBox(height: 20),
                    _inputField("Password", passwordController,
                        isPassword: true, iconData: Icons.lock),
                    SizedBox(height: 20),
                    _loginBtn(),
                    SizedBox(height: 20),
                    _signUpBtn(),
                    SizedBox(height: 50), // Added extra spacing at the bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.house_rounded,
        color: Colors.white,
        size: 150,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPassword = false, IconData? iconData}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: Colors.white),
    );

    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(iconData, color: Colors.white),
      ),
    );
  }

  Widget _loginBtn() {
    return ElevatedButton(
      onPressed: () async {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          _showErrorDialog("Please enter both email and password");
          return;
        }

        try {
          // Sign in with email and password
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Retrieve the user
          User? user = userCredential.user;
          if (user != null) {
            String uid = user.uid; // Get the user ID

            // Navigate to Home page and pass the UID and email
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  userId: uid, // Pass UID to Home page
                  email: user.email ??
                      "No email", // Pass email to Home page, handle null case
                ),
              ),
            );
          }
        } catch (e) {
          _showErrorDialog(e.toString());
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'SIGN IN',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _signUpBtn() {
    return ElevatedButton(
      onPressed: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'SIGN UP',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
