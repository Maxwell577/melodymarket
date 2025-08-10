import 'package:flutter/material.dart';
import 'package:melodymarket/screens/feed_screen.dart';
import 'package:melodymarket/screens/library_screen.dart';
import 'package:melodymarket/screens/profile_screen.dart';
import 'package:melodymarket/screens/artist_dashboard_screen.dart';
import 'package:melodymarket/widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isArtistMode = false; // Mock: would be determined by user account type

  List<Widget> get _screens {
    if (isArtistMode) {
      return [
        FeedScreen(), // Artists can still browse music
        ArtistDashboardScreen(), // Artist-specific dashboard
        LibraryScreen(),
        ProfileScreen(),
      ];
    } else {
      return [
        FeedScreen(), // Main discovery feed
        LibraryScreen(), // User's purchased music
        ProfileScreen(), // User profile
        Container(), // Placeholder for potential future screen
      ];
    }
  }

  List<BottomNavItem> get _navItems {
    if (isArtistMode) {
      return [
        BottomNavItem(
          icon: Icons.explore_outlined,
          selectedIcon: Icons.explore,
          label: 'Discover',
        ),
        BottomNavItem(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          label: 'Dashboard',
        ),
        BottomNavItem(
          icon: Icons.library_music_outlined,
          selectedIcon: Icons.library_music,
          label: 'Library',
        ),
        BottomNavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Profile',
        ),
      ];
    } else {
      return [
        BottomNavItem(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: 'Home',
        ),
        BottomNavItem(
          icon: Icons.library_music_outlined,
          selectedIcon: Icons.library_music,
          label: 'Library',
        ),
        BottomNavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Profile',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        items: _navItems,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: isArtistMode 
          ? FloatingActionButton(
              onPressed: () {
                // Quick access to upload track
                Navigator.pushNamed(context, '/upload-track');
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add, color: Colors.white),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                // Toggle between user and artist mode
                setState(() {
                  isArtistMode = !isArtistMode;
                  _selectedIndex = 0; // Reset to first tab
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArtistMode 
                          ? 'Switched to Artist Mode' 
                          : 'Switched to User Mode',
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              },
              icon: Icon(
                isArtistMode ? Icons.person : Icons.mic,
                color: Colors.white,
              ),
              label: Text(
                isArtistMode ? 'User Mode' : 'Artist Mode',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
      floatingActionButtonLocation: isArtistMode 
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat,
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}