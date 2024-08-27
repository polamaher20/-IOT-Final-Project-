import 'package:flutter/material.dart';
import 'pg.dart';
import 'loadingscreen.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class HomePage extends StatelessWidget {
  static Pg p1 = Pg(
    name_page: "kitchen",
    icon_page: Icons.kitchen,
    onLightSwitchChanged: (value) {
      print("Light switch changed to: $value");
    },
    onDoorSwitchChanged: (value) {
      print("Door switch changed to: $value");
    },
  );

  static Pg p2 = Pg(
    name_page: "Garage",
    icon_page: Icons.garage_sharp,
    onLightSwitchChanged: (value) {
      print("Light switch changed to: $value");
    },
    onDoorSwitchChanged: (value) {
      print("Door switch changed to: $value");
    },
  );

  static Pg p3 = Pg(
    name_page: "Living Room",
    icon_page: Icons.chair_rounded,
    onLightSwitchChanged: (value) {
      print("Light switch changed to: $value");
    },
    onDoorSwitchChanged: (value) {
      print("Door switch changed to: $value");
    },
  );

  static Pg p4 = Pg(
    name_page: "House Roof",
    icon_page: Icons.roofing,
    onLightSwitchChanged: (value) {
      print("Light switch changed to: $value");
    },
    onDoorSwitchChanged: (value) {
      print("Door switch changed to: $value");
    },
  );

  static Pg p5 = Pg(
    name_page: "Water Pumb",
    icon_page: Icons.grass_rounded,
    onLightSwitchChanged: (value) {
      print("Light switch changed to: $value");
    },
    onDoorSwitchChanged: (value) {
      print("Door switch changed to: $value");
    },
  );

  static Pg p6 = Pg(
    name_page: "TV",
    icon_page: Icons.tv_rounded,
    onLightSwitchChanged: (value) {
      print("Light switch changed to: $value");
    },
    onDoorSwitchChanged: (value) {
      print("Door switch changed to: $value");
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove debug banner from screen
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'SMART HOME',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('images/1.jpg'), // Update this to your image path
              fit: BoxFit.cover, // Adjust the image fit as needed
            ),
          ),
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(35, 90), // Move 20 pixels down
                child: Row(
                  children: [
                    BUTT(
                        icon: Icons.kitchen_sharp,
                        name: "Kitchen",
                        page: LoadingScreen(
                            Room_name: "Kitchen",
                            icon: Icons.kitchen,
                            page: p1) //
                        ),
                    SizedBox(
                      width: 20,
                    ),
                    BUTT(
                      icon: Icons.garage_sharp,
                      name: "Garage",
                      page: LoadingScreen(
                          Room_name: "Garage", icon: Icons.garage, page: p2),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(35, 130), // Move 20 pixels down
                child: Row(
                  children: [
                    BUTT(
                      icon: Icons.chair_rounded,
                      name: "Living room",
                      page: LoadingScreen(
                          Room_name: "Living room",
                          icon: Icons.chair_rounded,
                          page: p3),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    BUTT(
                      icon: Icons.roofing,
                      name: "Roof",
                      page: LoadingScreen(
                          Room_name: "Roof", icon: Icons.roofing, page: p4),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(35, 170), // Move 20 pixels down
                child: Row(
                  children: [
                    BUTT(
                      icon: Icons.grass,
                      name: "Water pumb",
                      page: LoadingScreen(
                          Room_name: "Water pumb", icon: Icons.grass, page: p5),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    BUTT(
                      icon: Icons.tv_sharp,
                      name: "TV",
                      page: LoadingScreen(
                          Room_name: "TV", icon: Icons.tv_sharp, page: p6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BUTT extends StatefulWidget {
  final IconData icon;
  final String name;
  final Widget page; // New parameter for the page to navigate to

  BUTT({
    required this.icon,
    required this.name,
    required this.page, // Initialize page parameter
  });

  @override
  _BUTTState createState() => _BUTTState();
}

class _BUTTState extends State<BUTT> {
  bool _isColored = false;

  void _Navigatetonewpage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: _isColored
                ? Colors.amber[600] // Change to desired color
                : Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.only(top: 15.0),
                onPressed: _Navigatetonewpage, // navigation to new page
                iconSize: 90,
                icon: Icon(
                  widget.icon,
                  color: Colors.purple[700],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white
                        .withOpacity(0.2), // Subtle semi-transparent background
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.purple.withOpacity(
                        0.3), // More pronounced overlay color for interaction
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Rounded corners for the button
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(
                      0), // Remove button elevation if not needed
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                widget.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0, // Added letter spacing
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
