import 'package:flutter/material.dart';

import '../home/screens/home_screen.dart';
import '../paper/screens/upload_paper_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../settings/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    UploadPaperScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        backgroundColor: const Color(0xFF1E293B),

        selectedItemColor: Colors.blueAccent,

        unselectedItemColor: Colors.white70,

        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: "Papers",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
