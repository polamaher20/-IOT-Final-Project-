import 'package:flutter/material.dart';
import 'setting.dart';
import 'user.dart';
import 'icon_page.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// void main() {
//   runApp(const Home());
// }

class Home extends StatefulWidget {
  // const Home({super.key});

  final String userId;
  final String email;

  Home({required this.userId, required this.email});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0; // Track the selected index

  PageController pageController = PageController();

  List<Widget> get pages => [
        HomePage(),
        Admin(
            userId1: widget.userId,
            email1: widget.email), // Pass parameters here
        SettingsPage(),
      ];

  void _onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
      pageController.jumpToPage(index); // to flip and swao between pages
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove debug banner from screen
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/1.jpg'), // Your image path
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
          child: PageView(
            controller: pageController,
            children: pages,
            onPageChanged: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.amber[600],
          backgroundColor: const Color.fromARGB(255, 209, 209, 208),
          selectedIndex: selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'User',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
