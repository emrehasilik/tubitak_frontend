import 'package:flutter/material.dart';
import 'package:tubitak_mobile/src/ui/screens/home_screen.dart';
import '../theme/app_colors.dart';

import 'screens/home_tab_screen.dart';
import 'screens/gardens_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeTabScreen(),
    GardensScreen(),
    SizedBox(), // kamera için boş
    RemindersScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Kamera ortadaki buton → ayrı açılır
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CameraScreen()),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: _pages[_selectedIndex],

      // ORTADAKİ KAMERA BUTONU
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CameraScreen()),
          );
        },
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDark.withOpacity(0.6),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Anasayfa  ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nature),
            label: "Bahçelerim",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Hatırlatmalar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
