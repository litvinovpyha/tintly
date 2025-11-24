import 'package:flutter/material.dart';
import 'package:tintly/app/settings_screen.dart';
import 'package:tintly/features/client/views/clients_screen.dart';
import 'package:tintly/features/home/views/home_screen.dart';
import 'package:tintly/features/history/views/history_screen.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/tab_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const tabs = ['Главная', 'Клиенты', 'История', 'Настройки'];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedPosition = 0;
  bool onboardingActive = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ClientsScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    // final prefs = await SharedPreferences.getInstance();
    // final seenIntro = prefs.getBool('seen_intro') ?? false;

    // if (!seenIntro) {
    // setState(() => onboardingActive = true);
    // }
  }

  Future<void> _finishOnboarding() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('seen_intro', true);
    setState(() => onboardingActive = false);
  }

  String _getOnboardingText(int index) {
    switch (index) {
      case 0:
        return 'На "Главной" отображается информация и быстрый доступ к функциям приложения';
      case 1:
        return 'Во вкладке "Клиенты" вы можете управлять своими клиентами, смотреть их профили и историю посещения.';
      case 2:
        return 'Раздел "История" показывает все действия и записи, связанные с вашими клиентами.';
      case 3:
        return 'Во вкладке "Настройки" можно изменить параметры приложения и записи.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: MainScreen.tabs[selectedPosition]),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.padding16),
            child: _screens[selectedPosition],
          ),
          if (onboardingActive)
            Positioned.fill(
              child: Stack(
                children: [
                  Container(color: Colors.black.withOpacity(0.2)),
                  // Собственно "воздушное" окно
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF006FFD),
                            borderRadius: BorderRadius.circular(
                              40,
                            ), // максимально округлые края
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 30,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 24),
                              Text(
                                _getOnboardingText(selectedPosition),
                                textAlign: TextAlign.center,
                                style: whiteTitleTextStyle,
                              ),
                              const SizedBox(height: 16),
                              if (selectedPosition < MainScreen.tabs.length - 1)
                                Text(
                                  'Нажмите на вкладку чтобы продолжить',
                                  textAlign: TextAlign.center,
                                  style: actionWhiteTextStyle,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomTab(),
    );
  }

  Widget _buildBottomTab() {
    return BottomAppBar(
      height: Dimens.height88,
      color: AppColor.surfaceColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          MainScreen.tabs.length,
          (index) => _buildTabItem(index, _getIconForTab(index)),
        ),
      ),
    );
  }

  IconData _getIconForTab(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.person;
      case 2:
        return Icons.analytics;
      case 3:
        return Icons.settings;
      default:
        return Icons.circle;
    }
  }

  Widget _buildTabItem(int index, IconData icon) {
    final isSelected = selectedPosition == index;

    // если включено обучение, подсвечиваем только текущую и следующую вкладку
    final bool isClickable =
        !onboardingActive ||
        index == selectedPosition ||
        index == selectedPosition + 1;

    // нужно ли применить анимацию пульсации
    final bool shouldPulse = onboardingActive && index == selectedPosition + 1;

    return Expanded(
      child: Opacity(
        opacity: onboardingActive ? (isClickable ? 1.0 : 0.3) : 1.0,
        child: IgnorePointer(
          ignoring: onboardingActive && !isClickable,
          child: _PulsingContainer(
            active: shouldPulse,
            child: TabItem(
              text: MainScreen.tabs[index],
              icon: icon,
              isSelected: isSelected,
              onTap: () {
                if (onboardingActive) {
                  if (index == selectedPosition ||
                      index == selectedPosition + 1) {
                    setState(() => selectedPosition = index);

                    if (index == _screens.length - 1) {
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        _finishOnboarding,
                      );
                    }
                  }
                } else {
                  setState(() => selectedPosition = index);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PulsingContainer extends StatefulWidget {
  final Widget child;
  final bool active;

  const _PulsingContainer({required this.child, required this.active});

  @override
  State<_PulsingContainer> createState() => _PulsingContainerState();
}

class _PulsingContainerState extends State<_PulsingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_PulsingContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;

    return ScaleTransition(
      scale: _animation,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 20,
              spreadRadius: 6,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
