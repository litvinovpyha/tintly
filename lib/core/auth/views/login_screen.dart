import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'dart:io' show Platform;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: AppColor.surfaceColor,
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Image.asset(
              'assets/images/bubble_wrap.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 0,
              ).copyWith(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Добро пожаловать!', style: h1TextStyle),
                  ),

                  const SizedBox(height: 16),

                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 32),
                  const Text('Войти с помощью:', style: primaryTextStyle),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(
                        icon: Icons.g_mobiledata_outlined,
                        color: Colors.white,
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),

                      if (Platform.isIOS)
                        _socialButton(
                          icon: Icons.apple,
                          color: Colors.black,
                          onTap: () {
                            Navigator.pushNamed(context, '/main');
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _socialButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(50),
    onTap: onTap,
    child: Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: const Color.fromARGB(255, 224, 212, 212),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 30),
    ),
  );
}
