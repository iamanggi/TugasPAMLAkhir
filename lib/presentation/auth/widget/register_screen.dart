import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tilik_desa/data/repository/Auth/auth_repository.dart';
import 'package:tilik_desa/presentation/auth/widget/login_screen.dart';
import 'package:tilik_desa/data/model/request/auth/register_request_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 0;
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  
  // Inisialisasi repository
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(ServiceHttpClient());
  }

  bool get isInputNotEmpty {
    switch (currentStep) {
      case 0:
        return nameController.text.isNotEmpty;
      case 1:
        return usernameController.text.isNotEmpty;
      case 2:
        return emailController.text.isNotEmpty;
      case 3:
        return passwordController.text.isNotEmpty;
      case 4:
        return confirmPasswordController.text.isNotEmpty &&
            confirmPasswordController.text == passwordController.text;
      default:
        return false;
    }
  }

  // Fungsi untuk registrasi menggunakan AuthRepository
  Future<void> registerUser() async {
    setState(() => isLoading = true);
    
    try {
      // Buat request model
      final registerRequest = RegisterRequestModel(
        nama: nameController.text,
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );
      
      // Panggil repository register
      final result = await _authRepository.register(registerRequest);
      
      result.fold(
        (error) {
          // Registrasi gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        },
        (success) {
          // Registrasi berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('registration_success'.tr),
              backgroundColor: Colors.green,
            ),
          );
          Get.to(() => LoginScreen());
        },
      );
    } catch (e) {
      // Handle unexpected error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      // Panggil fungsi registrasi sebenarnya
      registerUser();
    }
  }

  Widget getStepContent() {
    switch (currentStep) {
      case 0:
        return buildInputSection(
          title: 'step1_title'.tr,
          hint: 'step1_hint'.tr,
          controller: nameController,
        );
      case 1:
        return buildInputSection(
          title: 'step2_title'.tr,
          hint: 'step2_hint'.tr,
          controller: usernameController,
        );
      case 2:
        return buildInputSection(
          title: 'step3_title'.tr,
          hint: 'step3_hint'.tr,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        );
      case 3:
        return buildInputSection(
          title: 'step4_title'.tr,
          hint: 'step4_hint'.tr,
          controller: passwordController,
          obscure: true,
        );
      case 4:
        return buildInputSection(
          title: 'step5_title'.tr,
          hint: 'step5_hint'.tr,
          controller: confirmPasswordController,
          obscure: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildInputSection({
    required String title,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
          ),
        ),
        if (currentStep == 4 &&
            confirmPasswordController.text != passwordController.text &&
            confirmPasswordController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'password_not_match'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> stepLabels = [
      'step1_title'.tr,
      'step2_title'.tr,
      'step3_title'.tr,
      'step4_title'.tr,
      'step5_title'.tr,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              StepProgressIndicator(
                totalSteps: 5,
                currentStep: currentStep + 1,
                size: 10,
                padding: 6,
                selectedColor: Colors.green,
                unselectedColor: Colors.grey.shade300,
                roundedEdges: const Radius.circular(10),
              ),
              const SizedBox(height: 16),
              Text(
                '${'step'.tr} ${currentStep + 1} ${'of'.tr} 5: ${stepLabels[currentStep]}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              getStepContent(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (isInputNotEmpty && !isLoading) ? nextStep : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    disabledForegroundColor: Colors.white.withOpacity(0.7),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          currentStep < 4 ? 'next'.tr : 'finish'.tr,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}