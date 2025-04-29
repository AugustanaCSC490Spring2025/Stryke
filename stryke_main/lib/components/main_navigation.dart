import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/personal_screen.dart';

class MainNavigation extends StatefulWidget {
  final int index;

  // Constructor to receive the initial index
  const MainNavigation({super.key, required this.index});  // Default value for initialIndex

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;  // Default selected index

  final List<Widget> _screens = [
    HomePage(),
    PersonalScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize _selectedIndex with the value passed via the constructor
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _selectedIndex == 0
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFF1C1C1C), // Default background color
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black54, // Light line above the nav bar
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1C1C1C),
          selectedItemColor: const Color(0xFFB7FF00),
          unselectedItemColor: Colors.white54,
          currentIndex: _selectedIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

