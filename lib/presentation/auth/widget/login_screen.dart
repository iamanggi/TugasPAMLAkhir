import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilik_desa/core/core.dart';
import 'package:tilik_desa/data/model/request/auth/login_request_model.dart';
import 'package:tilik_desa/presentation/auth/bloc/login/login_bloc.dart';
import 'package:tilik_desa/presentation/auth/widget/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> _key;
  bool isShowPassword = false;
  String selectedLanguage = 'ID'; // 'ID' atau 'EN'

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _key = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _key.currentState?.dispose();
    super.dispose();
  }

  bool get isEnglish => selectedLanguage == 'EN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CupertinoSlidingSegmentedControl<String>(
              backgroundColor: Colors.grey.shade300,
              thumbColor: Colors.green,
              groupValue: selectedLanguage,
              children: const {
                'ID': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('ID', style: TextStyle(color: Colors.white)),
                ),
                'EN': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('EN', style: TextStyle(color: Colors.white)),
                ),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLanguage = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceHeight(40),
                Center(
                  child: Image.asset(
                    'assets/images/TilikDesa.png',
                    height: 100,
                  ),
                ),
                const SpaceHeight(20),
                Text(
                  isEnglish
                      ? 'Welcome to TilikDesa'
                      : 'Selamat datang di TilikDesa',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(10),
                Text(
                  isEnglish
                      ? 'TilikDesa: From Your Hands, For Village Progress!'
                      : 'TilikDesa: Dari Genggaman, untuk Kemajuan Desa!',
                  style: const TextStyle(fontSize: 16),
                ),
                const SpaceHeight(30),
                CustomTextField(
                  validator: isEnglish
                      ? 'Email cannot be empty'
                      : 'Email tidak boleh kosong',
                  controller: emailController,
                  label: 'Email',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.email),
                  ),
                ),
                const SpaceHeight(25),
                CustomTextField(
                  validator: isEnglish
                      ? 'Password cannot be empty'
                      : 'Password tidak boleh kosong',
                  controller: passwordController,
                  label: 'Password',
                  obscureText: !isShowPassword,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                    icon: Icon(
                      isShowPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                const SpaceHeight(30),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    } else if (state is LoginSuccess) {
                      final role = state.responseModel.data?.tokenType?.toLowerCase();
                      if (role == 'admin') {
                        // Navigasi admin
                      } else if (role == 'buyer') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.responseModel.message ?? "")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Role tidak dikenali')),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              if (_key.currentState!.validate()) {
                                final request = LoginRequestModel(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                context.read<LoginBloc>().add(
                                  LoginRequested(requestModel: request),
                                );
                              }
                            },
                      label: state is LoginLoading
                          ? 'Loading...'
                          : (isEnglish ? 'Login' : 'Masuk'),
                    );
                  },
                ),
                const SpaceHeight(20),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: isEnglish
                          ? "Don't have an account? "
                          : 'Belum memiliki akun? ',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      ),
                      children: [
                        TextSpan(
                          text: isEnglish
                              ? "Register here!"
                              : "Daftar disini!",
                          style: TextStyle(color: AppColors.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(
                                RegisterScreen(selectedLanguage: selectedLanguage),
                              );
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
