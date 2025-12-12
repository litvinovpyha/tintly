import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_event.dart';
import 'package:tintly/core/auth/bloc/auth_state.dart';
import 'package:tintly/core/routes/app_routes.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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

                const Text('', style: bodyTextStyle),
                const SizedBox(height: 4),
              ],
            ),

            const Spacer(),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is! Authenticated) {
                      return const SizedBox.shrink();
                    }

                    final user = state.user;

                    return user.role == 'admin'
                        ? Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  'Редактирование приложения',
                                  style: darkestTextStyle,
                                ),
                                trailing: chevronRight,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.settinngsEdit,
                                  );
                                },
                              ),
                              greyDivider,
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
                                          'Вы уверены? Чтобы редактировать приложение, вам потребуется снова войти.',
                                      confirm: 'Выйти',
                                    ),
                                  );

                                  if (confirm == true && context.mounted) {
                                    context.read<AuthBloc>().add(
                                      ChangeRoleRequested('master'),
                                    );
                                  }
                                },
                              ),
                              greyDivider,
                            ],
                          )
                        : Column(
                            children: [
                              greyDivider,

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
                                          'Вы уверены? Этот режим позволит вносить изменения.',
                                      confirm: 'Войти',
                                    ),
                                  );

                                  if (confirm == true && context.mounted) {
                                    context.read<AuthBloc>().add(
                                      ChangeRoleRequested('admin'),
                                    );
                                  }
                                },
                              ),
                              greyDivider,
                            ],
                          );
                  },
                ),
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
                            'Вы уверены, что хотите выйти? Вам потребуется снова войти.',
                        confirm: 'Выйти',
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      context.read<AuthBloc>().add(LogoutRequested());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
