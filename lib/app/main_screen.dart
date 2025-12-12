import 'package:flutter/material.dart';
import 'package:tintly/app/settings_screen.dart';
import 'package:tintly/features/client/views/clients_screen.dart';
import 'package:tintly/features/history/views/history_screen.dart';
import 'package:tintly/features/home/views/home_screen.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/tab_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const tabs = ['Главная', 'Клиенты', 'История', 'Настройки'];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedPosition = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ClientsScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(MainScreen.tabs[selectedPosition])),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.padding8),
            child: _screens[selectedPosition],
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
    return Expanded(
      child: TabItem(
        icon: icon,
        text: MainScreen.tabs[index],
        isSelected: isSelected,
        onTap: () {
          setState(() {
            selectedPosition = index;
          });
        },
      ),
    );
  }
}
