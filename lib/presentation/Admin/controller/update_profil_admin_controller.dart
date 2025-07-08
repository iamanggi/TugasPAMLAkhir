import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tilik_desa/data/model/request/admin/profil_update_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/profil_update_admin_response_model.dart';
import 'package:tilik_desa/data/repository/Admin/profil_update_admin_repository.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class UpdateProfilAdminController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final villageController = TextEditingController();
  final subDistrictController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final isLoadingProfile = false.obs;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  final _repo = AdminProfileRepository(ServiceHttpClient());
  
  // Data profil admin yang sedang login
  AdminProfileData? currentProfile;

  void pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (picked != null) {
        selectedImage = File(picked.path);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Ambil data profil dari server
  Future<void> loadProfile() async {
    try {
      isLoadingProfile.value = true;
      
      final result = await _repo.getMyProfile();
      
      result.fold(
        (error) {
          Get.snackbar(
            'Error',
            'Gagal memuat profil: $error',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (response) {
          if (response.success && response.data != null) {
            currentProfile = response.data!;
            _populateFormWithProfileData();
          } else {
            Get.snackbar(
              'Error',
              response.message.isNotEmpty ? response.message : 'Gagal memuat data profil',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat profil: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Isi form dengan data profil yang sudah ada
  void _populateFormWithProfileData() {
    if (currentProfile != null) {
      namaController.text = currentProfile!.nama;
      phoneController.text = currentProfile!.phone ?? '';
      addressController.text = currentProfile!.address ?? '';
      villageController.text = currentProfile!.village ?? '';
      subDistrictController.text = currentProfile!.subDistrict ?? '';
      
      // Reset password fields
      passwordController.clear();
      confirmPasswordController.clear();
      
      update();
    }
  }

  void updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validasi password jika diisi
    if (password.isNotEmpty && password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Konfirmasi password tidak cocok',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi minimal ada perubahan
    if (_isNoChange() && selectedImage == null) {
      Get.snackbar(
        'Info',
        'Tidak ada perubahan yang perlu disimpan',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final request = AdminProfileUpdateRequestModel(
      nama: namaController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      village: villageController.text.trim(),
      subDistrict: subDistrictController.text.trim(),
      password: password.isNotEmpty ? password : null,
      passwordConfirmation: password.isNotEmpty ? confirmPassword : null,
      photo: selectedImage,
    );

    isLoading.value = true;

    try {
      final result = await _repo.updateMyProfile(request);

      result.fold(
        (error) => Get.snackbar(
          'Gagal',
          error,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        ),
        (response) {
          if (response.success) {
            // Update current profile dengan data baru
            if (response.data != null) {
              currentProfile = response.data;
            }
            
            // Reset password fields setelah berhasil
            passwordController.clear();
            confirmPasswordController.clear();
            selectedImage = null;
            
            Get.back(result: true);
            Get.snackbar(
              'Berhasil',
              response.message.isNotEmpty ? response.message : 'Profil berhasil diperbarui',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Gagal',
              response.message.isNotEmpty ? response.message : 'Gagal memperbarui profil',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Cek apakah tidak ada perubahan data
  bool _isNoChange() {
    if (currentProfile == null) return false;
    
    return namaController.text.trim() == currentProfile!.nama &&
           phoneController.text.trim() == (currentProfile!.phone ?? '') &&
           addressController.text.trim() == (currentProfile!.address ?? '') &&
           villageController.text.trim() == (currentProfile!.village ?? '') &&
           subDistrictController.text.trim() == (currentProfile!.subDistrict ?? '') &&
           passwordController.text.isEmpty;
  }

  /// Refresh data profil
  void refreshProfile() {
    loadProfile();
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile(); // Load data profil saat controller diinisialisasi
  }

  @override
  void onClose() {
    namaController.dispose();
    phoneController.dispose();
    addressController.dispose();
    villageController.dispose();
    subDistrictController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}