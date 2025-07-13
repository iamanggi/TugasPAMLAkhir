import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tilik_desa/presentation/User/bloc/dashboard_user/dashboard_user_bloc.dart';
import 'package:tilik_desa/presentation/User/widget/update_profile_user.dart';
import 'package:tilik_desa/presentation/auth/widget/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isBahasaIndonesia = true;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    context.read<DashboardUserBloc>().add(LoadDashboardUser());
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('bahasa') ?? true;
    setState(() => isBahasaIndonesia = value);
    Get.updateLocale(
      value ? const Locale('id', 'ID') : const Locale('en', 'US'),
    );
  }

  Future<void> _toggleBahasa(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bahasa', value);
    setState(() => isBahasaIndonesia = value);
    Get.updateLocale(
      value ? const Locale('id', 'ID') : const Locale('en', 'US'),
    );
  }

  Future<void> _logout() async {
    final confirmed = await Get.defaultDialog<bool>(
      title: 'logout'.tr,
      middleText: 'logout_confirmation'.tr,
      textCancel: 'cancel'.tr,
      textConfirm: 'logout'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await Future.delayed(const Duration(milliseconds: 300));
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('settings'.tr),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<DashboardUserBloc, DashboardUserState>(
        builder: (context, state) {
          dynamic userData;
          String? photoUrl;
          bool isLoading = true;

          if (state is DashboardUserLoaded) {
            userData = state.dashboard.data?.user;
            final photoPath = state.dashboard.data?.user?.photo;
            if (photoPath != null && photoPath.isNotEmpty) {
              photoUrl = 'http://192.168.0.111:8888/storage/$photoPath';
            }

            isLoading = false;
          }

          final displayName = userData?.nama ?? 'user'.tr;
          final initials = _getInitials(displayName);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardUserBloc>().add(LoadDashboardUser());
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildProfileCard(displayName, initials, photoUrl, isLoading),
                const SizedBox(height: 24),
                _buildLanguageCard(),
                const SizedBox(height: 16),
                _buildLogoutCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(
    String displayName,
    String initials,
    String? photoUrl,
    bool isLoading,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () async {
          final result = await Get.to(() => const UpdateProfilUserScreen());
          if (result == true) {
            context.read<DashboardUserBloc>().add(LoadDashboardUser());
          }
        },
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child:
              isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : (photoUrl != null && photoUrl.isNotEmpty)
                  ? ClipOval(
                    child: Image.network(
                      photoUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                    ),
                  )
                  : Text(
                    initials,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.edit, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text('edit_profile'.tr),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.language, color: Colors.green.shade700),
        ),
        title: Text('language'.tr),
        subtitle: Text(
          isBahasaIndonesia ? 'bahasa_indonesia'.tr : 'english'.tr,
        ),
        trailing: Switch(
          value: isBahasaIndonesia,
          onChanged: _toggleBahasa,
          activeColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildLogoutCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: _logout,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.logout, color: Colors.red.shade700),
        ),
        title: Text('logout'.tr),
        subtitle: Text('logout_desc'.tr),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return 'U';
  }
}
