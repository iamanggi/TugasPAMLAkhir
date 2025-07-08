import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tilik_desa/presentation/Admin/bloc/dashboard_admin/dashboard_admin_bloc.dart';

class AdminSettingsController extends ChangeNotifier {
  final DashboardAdminBloc dashboardBloc;
  bool isBahasaIndonesia = true;

  AdminSettingsController({required this.dashboardBloc}) {
    _loadLanguagePreference();
    dashboardBloc.add(LoadDashboardAdmin());
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isBahasaIndonesia = prefs.getBool('bahasa') ?? true;
    Get.updateLocale(isBahasaIndonesia ? const Locale('id', 'ID') : const Locale('en', 'US'));
    notifyListeners();
  }

  Future<void> toggleBahasa(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bahasa', value);
    isBahasaIndonesia = value;
    Get.updateLocale(value ? const Locale('id', 'ID') : const Locale('en', 'US'));
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
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
      Get.offAllNamed('/login');
    }
  }
}
