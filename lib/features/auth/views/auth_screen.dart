import 'package:flutter/material.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'dart:io' show Platform;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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

                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Телефон',
                      hintStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.6),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0x33000000),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0x33000000),
                          width: 1,
                        ),
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),

                  const SizedBox(height: 16),

                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: primaryColor,
                  //       foregroundColor: Colors.white,
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //       minimumSize: const Size(0, 48),

                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //     child: const Text('Войти', style: actionWhiteTextStyle),
                  //   ),
                  // ),
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
                        color: Colors.redAccent,
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                      _socialButton(
                        icon: Icons.alternate_email,
                        color: Colors.redAccent,
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),

                      const SizedBox(width: 20),
                      if (Platform.isIOS)
                        _socialButton(
                          icon: Icons.apple,
                          color: Colors.black,
                          onTap: () {},
                        ),
                      if (Platform.isIOS) const SizedBox(width: 20),
                      _socialButton(
                        icon: Icons.admin_panel_settings,
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MainScreen()),
                          );
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
        color: Colors.white,
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
