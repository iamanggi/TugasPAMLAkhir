import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class RegisterScreen extends StatefulWidget {
  final String selectedLanguage;

  const RegisterScreen({super.key, required this.selectedLanguage});

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

  bool get isEnglish => widget.selectedLanguage == 'EN';

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

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEnglish
              ? 'Registration successful!'
              : 'Registrasi berhasil!'),
        ),
      );
    }
  }

  Widget getStepContent() {
    switch (currentStep) {
      case 0:
        return buildInputSection(
          title: isEnglish ? "What's your name?" : "Siapa nama kamu?",
          hint: isEnglish ? "Full name" : "Nama lengkap",
          controller: nameController,
        );
      case 1:
        return buildInputSection(
          title: isEnglish ? "Choose a unique username" : "Pilih username unik",
          hint: "Username",
          controller: usernameController,
        );
      case 2:
        return buildInputSection(
          title: isEnglish ? "Enter your email" : "Masukkan email kamu",
          hint: "Email",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        );
      case 3:
        return buildInputSection(
          title: isEnglish ? "Create a secure password" : "Buat password aman",
          hint: isEnglish ? "Password" : "Kata sandi",
          controller: passwordController,
          obscure: true,
        );
      case 4:
        return buildInputSection(
          title: isEnglish ? "Confirm your password" : "Konfirmasi password",
          hint: isEnglish ? "Repeat password" : "Ulangi kata sandi",
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
              isEnglish ? 'Passwords do not match' : 'Password tidak cocok',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> stepLabels = isEnglish
        ? ['Name', 'Username', 'Email', 'Password', 'Confirm']
        : ['Nama', 'Username', 'Email', 'Password', 'Konfirmasi'];

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
                "${isEnglish ? 'Step' : 'Langkah'} ${currentStep + 1} ${isEnglish ? 'of' : 'dari'} 5: ${stepLabels[currentStep]}",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              getStepContent(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isInputNotEmpty ? nextStep : null,
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
                  child: Text(
                    currentStep < 4
                        ? (isEnglish ? "Next" : "Lanjutkan")
                        : (isEnglish ? "Finish" : "Selesai"),
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
