import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/features/auth/views/auth_screen.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? role;
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _loadRole();
    });
  }

  Future<void> _loadRole() async {
    final box = await Hive.openBox('authBox');
    setState(() {
      role = box.get('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding16),
          child: Column(
            children: [
              Column(
                children: [
                  Stack(
                    alignment: AlignmentGeometry.bottomRight,
                    children: [
                      Image.asset('assets/images/avatar80x80.png'),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColor.primaryColor,
                        child: Icon(
                          Icons.edit,
                          size: 17,
                          color: AppColor.surfaceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Администратор', style: titleH3TextStyle),
                  const SizedBox(height: 4),
                  const Text('@admin', style: bodyTextStyle),
                  const SizedBox(height: 4),
                ],
              ),

              const Spacer(),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (role == 'admin')
                    ListTile(
                      title: const Text(
                        'Редактирование приложения',
                        style: darkestTextStyle,
                      ),
                      trailing: chevronRight,
                      onTap: () async {
                        Navigator.pushNamed(context, '/settings/edit');
                      },
                    ),
                  if (role == 'admin') greyDivider,

                  if (role == 'admin')
                    ListTile(
                      title: const Text(
                        'Выход из редактирования',
                        style: darkestTextStyle,
                      ),
                      trailing: chevronRight,
                      onTap: () async {
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => ChoiceDialog(
                            title: 'Выйти',
                            description:
                                'Вы уверены? Чтобы редактировать приложение, вам потребуется снова войти в режим редактирования.',
                            confirm: 'Выйти',
                          ),
                        );

                        if (confirm == true) {
                          final box = await Hive.openBox('authBox');

                          await box.put('role', 'master');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MainScreen()),
                          );
                        }
                      },
                    ),
                  if (role != 'admin')
                    ListTile(
                      title: const Text(
                        'Войти в режим редактирования',
                        style: darkestTextStyle,
                      ),
                      trailing: chevronRight,
                      onTap: () async {
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => ChoiceDialog(
                            title: 'Войти',
                            description:
                                'Вы уверены? Данный режим позволит вносить изменения в приложении.',
                            confirm: 'Войти',
                          ),
                        );

                        if (confirm == true) {
                          final box = await Hive.openBox('authBox');

                          await box.put('role', 'admin');

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MainScreen()),
                          );
                        }
                      },
                    ),
                  greyDivider,

                  ListTile(
                    title: const Text(
                      'Выйти из аккаунта',
                      style: darkestTextStyle,
                    ),
                    trailing: chevronRight,
                    onTap: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ChoiceDialog(
                          title: 'Выход',
                          description:
                              'Вы уверены, что хотите выйти? Чтобы использовать приложение, вам потребуется снова войти.',
                          confirm: 'Выйти',
                        ),
                      );

                      if (confirm == true) {
                        final box = await Hive.openBox('authBox');
                        await box.clear();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
