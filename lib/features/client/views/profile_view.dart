import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_state.dart';
import 'package:tintly/features/client/bloc/client_bloc.dart';
import 'package:tintly/features/client/bloc/client_event.dart';
import 'package:tintly/features/client/bloc/client_state.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';
import 'package:tintly/shared/widgets/show_placeholder_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is ClientLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is ClientError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is ClientItemLoaded) {
          final client = state.client;

          return Scaffold(
            appBar: AppBar(
              title: Text(client.name),

              actions: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is! Authenticated) {
                      return const SizedBox.shrink();
                    }
                    if (state.user.role == 'admin') {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimens.padding16),
                        child: InkWell(
                          onTap: () async {
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ChoiceDialog(
                                title: 'Удалить',
                                description: 'Вы уверены?',
                                confirm: 'Удалить',
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              context.read<ClientBloc>().add(
                                DeleteClient(client.id),
                              );
                            }
                          },
                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.padding8),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: client.photo != null
                              ? AssetImage(client.photo!)
                              : const AssetImage('assets/images/avatar.png'),
                        ),

                        const SizedBox(height: Dimens.width16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                final newWhatsapp = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    return const EditDialog(
                                      label: 'Изменить:',
                                      description: '',
                                      confirm: 'Подтвердить',
                                      data: "",
                                    );
                                  },
                                );
                                if (newWhatsapp != null && context.mounted) {
                                  context.read<ClientBloc>().add(
                                    UpdateClient(whatsapp: newWhatsapp),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                child: Image.asset('assets/icons/whatsapp.png'),
                              ),
                            ),
                            const SizedBox(width: Dimens.width16),
                            InkWell(
                              onTap: () async {
                                final newInstagram = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    return const EditDialog(
                                      label: 'Изменить:',
                                      description: '',
                                      confirm: 'Подтвердить',
                                      data: "",
                                    );
                                  },
                                );
                                if (newInstagram != null && context.mounted) {
                                  context.read<ClientBloc>().add(
                                    UpdateClient(instagram: newInstagram),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                child: Image.asset(
                                  'assets/icons/instagram.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimens.width16),
                            InkWell(
                              onTap: () async {
                                final newTelegram = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    return const EditDialog(
                                      label: 'Изменить:',
                                      description: '',
                                      confirm: 'Подтвердить',
                                      data: "",
                                    );
                                  },
                                );
                                if (newTelegram != null && context.mounted) {
                                  context.read<ClientBloc>().add(
                                    UpdateClient(telegram: newTelegram),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/icons/telegram.png'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimens.width8),

                        InkWell(
                          onTap: () async {
                            if (client.phone == null) {
                              final newPhone = await showDialog<String>(
                                context: context,
                                builder: (context) {
                                  return const EditDialog(
                                    label: 'Изменить:',
                                    description: '',
                                    confirm: 'Подтвердить',
                                    data: "",
                                  );
                                },
                              );

                              if (newPhone != null && context.mounted) {
                                context.read<ClientBloc>().add(
                                  UpdateClient(phone: newPhone),
                                );
                              }
                            } else {
                              final Uri url = Uri(
                                scheme: 'tel',
                                path: client.phone,
                              );

                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                if (context.mounted) {
                                  await showPlaceholderDialog(
                                    context,
                                    title: 'Работает на реальном устройстве',
                                    message: '',
                                  );
                                }
                              }
                            }
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 38,
                              width: 138,

                              child: Card(
                                color: AppColor.darkestColor,

                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        client.phone ?? 'Добавить номер',
                                        style: actionWhiteTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
              
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('Инициализация...'));
      },
    );
  }
}
