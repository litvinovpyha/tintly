import 'package:flutter/material.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: data.length,
              onPageChanged: (value) {
                setState(() {
                  _pageIndex = value;
                });
              },
              itemBuilder: (context, index) => OnBoardingContent(
                image: data[index].image,
                title: data[index].title,
                description: data[index].description,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Row(
              children: [
                ...List.generate(
                  data.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: DotIndicator(isActive: index == _pageIndex),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: Dimens.height64,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_pageIndex == data.length - 1) {
                        // реализовать онбординг
                        // final prefs = await SharedPreferences.getInstance();
                        // await prefs.setBool('hasSeenOnboarding', true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColor.primaryColor,
                    ),
                    child: Transform.rotate(
                      angle: 3.14,
                      child: Image.asset(
                        'assets/icons/back.png',
                        color: AppColor.surfaceColor,
                      ),
                    ),
                    // child: Icon(
                    //   size: 24,
                    //   Icons.arrow_right_alt_outlined,
                    //   color: surfaceColor,
                    // ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 88),
        ],
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, this.isActive = false});
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive
            ? AppColor.primaryColor
            : AppColor.primaryColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius10)),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<Onboard> data = [
  Onboard(
    image: 'assets/images/bubble_wrap.jpg',
    title: 'Добро пожаловать в Tintly!',
    description:
        'Приложение, которое помогает вести подсчет окрашивания колористам.',
  ),
  Onboard(
    image: 'assets/images/bubble_wrap.jpg',
    title: 'Все под контролем.',
    description: 'Храните клиентов и расчёты в одном месте. Удобно и быстро',
  ),
  Onboard(
    image: 'assets/images/bubble_wrap.jpg',
    title: 'Экономьте время',
    description:
        'Мы сделали всё, чтобы вы могли сосредоточиться на деле, а не на бумажках.',
  ),
  Onboard(
    image: 'assets/images/bubble_wrap.jpg',
    title: 'Готовы начать?',
    description:
        'Создайте свой первый калькулятор и попробуйте все возможности приложения прямо сейчас!',
  ),
];

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    super.key,
    required this.image,

    required this.title,
    required this.description,
  });
  final String image, title, description;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 7,
          child: Image.asset(image, width: double.infinity, fit: BoxFit.cover),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
               Text(
                title,
                style: h1TextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.height24),
               Text(
                description,
                style: bodyh4TextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.height52),
            ],
          ),
        ),
      ],
    );
  }
}
