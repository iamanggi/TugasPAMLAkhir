import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tilik_desa/core/core.dart';
import 'package:tilik_desa/presentation/User/controller/update_profil_user_controller.dart';

class UpdateProfilUserScreen extends StatelessWidget {
  const UpdateProfilUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfilUserController>(
      init: UpdateProfilUserController(),
      builder:
          (controller) => Scaffold(
            appBar: AppBar(
              title: Text('edit_profile'.tr),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.refreshProfile,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            backgroundColor: Colors.grey[50],
            body: Obx(() {
              if (controller.isLoadingProfile.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Memuat data profil...'),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    controller.selectedImage != null
                                        ? FileImage(controller.selectedImage!)
                                        : controller.currentProfile?.photo !=
                                            null
                                        ? NetworkImage(
                                          'http://192.168.0.111:8888/storage/${controller.currentProfile!.photo}',
                                        )
                                        : null,
                                child:
                                    controller.selectedImage == null &&
                                            controller.currentProfile?.photo ==
                                                null
                                        ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey[600],
                                        )
                                        : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: controller.pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SpaceHeight(24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Pastikan data yang Anda masukkan sudah benar sebelum menyimpan.',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SpaceHeight(24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Colors.blue[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'personal_info'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SpaceHeight(16),

                            CustomTextField(
                              label: 'name'.tr,
                              controller: controller.namaController,
                              prefixIcon: const Icon(Icons.person),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'name_required'.tr;
                                }
                                if (value.length < 2) {
                                  return 'Nama minimal 2 karakter';
                                }
                                return null;
                              },
                            ),
                            const SpaceHeight(16),

                            CustomTextField(
                              label: 'phone'.tr,
                              controller: controller.phoneController,
                              prefixIcon: const Icon(Icons.phone),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'phone_required'.tr;
                                }
                                if (value.length < 10) {
                                  return 'No HP minimal 10 digit';
                                }
                                return null;
                              },
                            ),
                            const SpaceHeight(16),

                            CustomTextField(
                              label: 'address'.tr,
                              controller: controller.addressController,
                              prefixIcon: const Icon(Icons.home),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'location_detail_required'.tr;
                                }
                                return null;
                              },
                            ),
                            const SpaceHeight(16),

                            CustomTextField(
                              label: 'village'.tr,
                              controller: controller.villageController,
                              prefixIcon: const Icon(Icons.location_city),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'village_required'.tr;
                                }
                                return null;
                              },
                            ),
                            const SpaceHeight(16),

                            CustomTextField(
                              label: 'sub_district'.tr,
                              controller: controller.subDistrictController,
                              prefixIcon: const Icon(Icons.map),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'sub_district_required'.tr;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SpaceHeight(24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.security, color: Colors.red[600]),
                                const SizedBox(width: 8),
                                Text(
                                  'security'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SpaceHeight(8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber,
                                    color: Colors.amber[700],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'password_note'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.amber[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SpaceHeight(16),

                            Obx(
                              () => CustomTextField(
                                label: 'new_password'.tr,
                                controller: controller.passwordController,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed:
                                      () =>
                                          controller.isPasswordVisible.toggle(),
                                ),
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (value.length < 6) {
                                      return 'password_min'.tr;
                                    }
                                    if (!RegExp(
                                      r'^(?=.*[a-zA-Z])(?=.*\d)',
                                    ).hasMatch(value)) {
                                      return 'Password harus mengandung huruf dan angka';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SpaceHeight(16),

                            Obx(
                              () => CustomTextField(
                                label: 'confirm_password'.tr,
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    !controller.isConfirmPasswordVisible.value,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isConfirmPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed:
                                      () =>
                                          controller.isConfirmPasswordVisible
                                              .toggle(),
                                ),
                                validator: (value) {
                                  final password =
                                      controller.passwordController.text;
                                  if (password.isNotEmpty &&
                                      value != password) {
                                    return 'confirm_password_error'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SpaceHeight(32),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null
                                    : controller.updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child:
                                controller.isLoading.value
                                    ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text('loading'.tr),
                                      ],
                                    )
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'save_changes'.tr,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),

                      const SpaceHeight(16),
                      Center(
                        child: Text(
                          'Data yang sudah disimpan tidak dapat dikembalikan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SpaceHeight(20),
                    ],
                  ),
                ),
              );
            }),
          ),
    );
  }
}
