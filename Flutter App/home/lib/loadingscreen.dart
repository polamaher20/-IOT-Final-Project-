import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class LoadingScreen extends StatefulWidget {
  final Widget page; // Page to navigate to after loading
  final IconData icon; // Icon to use in the loading animation
  final String Room_name;
  
  LoadingScreen({
    required this.page,
    required this.icon,
    required this.Room_name,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.page), // Use widget.page
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.Room_name,
          style:TextStyle(
            fontWeight:FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2.0 * 3.14,
              child: Icon(
                widget.icon, // Use widget.icon
                size: 100,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
    );
  }
}
