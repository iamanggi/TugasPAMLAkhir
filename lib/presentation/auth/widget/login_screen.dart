import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tilik_desa/core/core.dart';
import 'package:tilik_desa/core/navigations/admin_botom_navigation.dart';
import 'package:tilik_desa/core/navigations/user_botom_navigation.dart';
import 'package:tilik_desa/data/model/request/auth/login_request_model.dart';
import 'package:tilik_desa/presentation/Admin/widget/dashbord_admin_screen.dart';
import 'package:tilik_desa/presentation/User/widget/dashboard_user.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CupertinoSlidingSegmentedControl<Locale>(
              backgroundColor: Colors.grey.shade300,
              thumbColor: Colors.green,
              groupValue: Get.locale,
              children: {
                const Locale('id', 'ID'): Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text('ID', style: TextStyle(color: Colors.white)),
                ),
                const Locale('en', 'US'): Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text('EN', style: TextStyle(color: Colors.white)),
                ),
              },
              onValueChanged: (value) {
                if (value != null) {
                  Get.updateLocale(value);
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
                  'welcome'.tr,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(10),
                Text('slogan'.tr, style: const TextStyle(fontSize: 16)),
                const SpaceHeight(30),

                // Email
                CustomTextField(
                  label: 'email'.tr,
                  controller: emailController,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email_required'.tr;
                    }
                    return null;
                  },
                ),
                const SpaceHeight(25),

                // Password
                CustomTextField(
                  label: 'password'.tr,
                  controller: passwordController,
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
                      isShowPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'password_required'.tr;
                    }
                    return null;
                  },
                ),
                const SpaceHeight(30),

                // Login Button
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      final role =
                          state.responseModel.data?.user?.role?.toLowerCase();
                      if (role == 'masyarakat') {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const UserBottomNavigation(),
                          ),
                          (route) => false,
                        );
                      } else if (role == 'admin') {
                        context.pushReplacement(const AdminBottomNavigation());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('unrecognized_role'.tr)),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed:
                          state is LoginLoading
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
                      label: state is LoginLoading ? 'loading'.tr : 'login'.tr,
                    );
                  },
                ),
                const SpaceHeight(20),

                // Register Link
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'no_account'.tr,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      ),
                      children: [
                        TextSpan(
                          text: 'register_here'.tr,
                          style: TextStyle(color: AppColors.primary),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(const RegisterScreen());
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
