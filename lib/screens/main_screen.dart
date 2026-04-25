import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_content.dart';
import 'browse_screen.dart';
import 'my_requests_screen.dart';
// Future placeholders for Messages and Profile
import 'profile_screen.dart';
import 'conversation_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const BrowseRequestsScreen(),
    const MyRequestsScreen(),
    const ConversationListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.explore, Icons.explore_outlined, 'Browse'),
                _buildNavItem(2, Icons.add_circle, Icons.add_circle_outline, 'Post'),
                _buildNavItem(3, Icons.chat_bubble, Icons.chat_bubble_outline, 'Messages'),
                _buildNavItem(4, Icons.person, Icons.person_outline, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData outlineIcon, String label) {
    bool isSelected = _selectedIndex == index;
    const primaryColor = Color(0xFF005BBF);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? icon : outlineIcon,
              color: isSelected ? primaryColor : Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
