import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _textScaleController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _iconController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _textController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _textScaleController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _iconController.forward().then((_) {
      _textController.forward();
      _textScaleController.forward();
    });

    // Wait for the animation to complete and then navigate to the LoginPage
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context)
            .pushReplacement(_createScalePageRoute(LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _textScaleController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffB81736),
            Color(0xff281537)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _animatedIcon(),
            SizedBox(height: 20),
            _animatedText(),
          ],
        ),
      ),
    );
  }

  Widget _animatedIcon() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.easeOut),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.home,
          color: Colors.white,
          size: 150,
        ),
      ),
    );
  }

  Widget _animatedText() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeOut),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: _textScaleController, curve: Curves.easeOut),
        ),
        child: Text(
          'Welcome to your Smart Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            fontFamily: 'Orbitron',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  PageRouteBuilder _createScalePageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the animation
        var scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );

        // Apply the transition
        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      transitionDuration: Duration(seconds: 2),
    );
  }
}
