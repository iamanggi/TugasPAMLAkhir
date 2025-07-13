import 'package:flutter/material.dart';
import 'package:tilik_desa/presentation/Admin/widget/categori_page_screen.dart';
import 'package:tilik_desa/presentation/Admin/widget/dashbord_admin_screen.dart';
import 'package:tilik_desa/presentation/Admin/widget/pemeliharaan_admin_screen.dart';
import 'package:tilik_desa/presentation/Admin/widget/pengaturan_admin.dart';
import 'package:tilik_desa/presentation/Admin/widget/riwayat_report_admin_screen.dart';

class AdminBottomNavigation extends StatefulWidget {
  const AdminBottomNavigation({super.key});

  @override
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardAdminScreen(),
    AdminReportListPage(),
    CategoryPage(),
    PemeliharaanAdminScreen(),
    AdminSettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_search), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Peta'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Pemeliharaan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
