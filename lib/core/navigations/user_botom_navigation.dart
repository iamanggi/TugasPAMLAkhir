import 'package:flutter/material.dart';
import 'package:tilik_desa/presentation/User/widget/dashboard_user.dart';
import 'package:tilik_desa/presentation/User/widget/report_user.dart';
import 'package:tilik_desa/presentation/User/widget/riwayat_report_user.dart';
import 'package:tilik_desa/presentation/User/widget/pengaturan_user.dart';
import 'package:get/get.dart';

class UserBottomNavigation extends StatefulWidget {
  const UserBottomNavigation({super.key});

  @override
  State<UserBottomNavigation> createState() => _UserBottomNavigationState();
}

class _UserBottomNavigationState extends State<UserBottomNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = const [
    DashboardUserScreen(),
    CameraScreen(),
    CameraScreen(),
    RiwayatLaporanPage(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _currentIndex = 1); // Navigate to CameraScreen
        },
        child: const Icon(Icons.add),
        tooltip: "new_report".tr,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard, 'Dashboard', 0),
              _buildNavItem(Icons.camera_alt, 'Camera', 1),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(Icons.history, 'Riwayat', 3),
              _buildNavItem(Icons.settings, 'Pengaturan', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}