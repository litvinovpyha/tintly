import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tintly/features/admin/controllers/calculator_session_controller.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/features/client/bloc/client_bloc.dart';
import 'package:tintly/features/client/bloc/client_state.dart';
import 'package:tintly/features/client/views/client_profile_screen.dart';
import 'package:tintly/features/master/views/select_client.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class FeatureHistoryScreen extends StatefulWidget {
  const FeatureHistoryScreen({super.key});

  @override
  State<FeatureHistoryScreen> createState() => _FeatureHistoryScreenState();
}

class _FeatureHistoryScreenState extends State<FeatureHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final controller = Provider.of<CalculatorSessionController>(
      context,
      listen: false,
    );

    return FutureBuilder(
      future: controller.getItem(id),
      builder: (context, sessionSnapshot) {
        if (sessionSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (sessionSnapshot.hasError) {
          return Center(child: Text('Ошибка: ${sessionSnapshot.error}'));
        } else if (!sessionSnapshot.hasData) {
          return const Center(child: Text('Нет данных'));
        }

        final session = sessionSnapshot.data!;

        return BlocBuilder<ClientBloc, ClientState>(
          builder: (context, state) {
            if (state is ClientSingleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ClientSingleError) {
              return Center(child: Text("Ошибка клиента: ${state.message}"));
            }
            if (state is ClientSingleLoaded) {
              final client = state.client;
              return Scaffold(
                appBar: CustomAppBar(title: 'Информация о услуге', actions: []),
                body: Padding(
                  padding: const EdgeInsets.all(Dimens.padding16),
                  child: Column(
                    children: [
                      CustomListTile(
                        title: 'Создано:',
                        subtitle: Text(
                          DateFormat(
                            'd MMMM yyyy',
                            'ru_RU',
                          ).format(session.createdAt),
                        ),
                      ),
                      CustomListTile(
                        onTap: () async {
                          final controller =
                              Provider.of<CalculatorSessionController>(
                                context,
                                listen: false,
                              );
                          if (client != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ClientProfileScreen(client: client),
                              ),
                            );
                          }
                          if (client == null) {
                            final selectedClientId = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SelectClient(),
                              ),
                            );
                            if (selectedClientId != null) {
                              final updatedSession = session.copyWith(
                                clientId: selectedClientId,
                              );

                              await controller.update(updatedSession);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Сессия сохранена"),
                                  ),
                                );

                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        title: 'Клиент:',
                        subtitle: Text(
                          client?.name ?? 'Добавить клиента?',
                          style: darkestTextStyle,
                        ),
                        divider: false,
                      ),
                      CustomListTile(title: 'До/После', divider: false),
                      BeforeAfterUploader(
                        session: session,
                        controller: controller,
                      ),

                      SizedBox(height: Dimens.height24),
                      CustomListTile(
                        title: 'Затраченные Материалы:',
                        divider: false,
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: session.consumptionData?.length ?? 0,
                          itemBuilder: (context, index) {
                            final key = session.consumptionData!.keys.elementAt(
                              index,
                            );
                            final value = session.consumptionData!.values
                                .elementAt(index);

                            return CustomListTile(
                              trailing: Text(
                                "${value.toStringAsFixed(0)} ед.",
                                style: headingH5TextStyle,
                              ),
                              title: key,
                              subtitle: const Text("", style: darkestTextStyle),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
          // future: clientController.getClient(session.clientId),
          // builder: (context, clientSnapshot) {
          //   if (clientSnapshot.connectionState == ConnectionState.waiting) {
          //     return const Center(child: CircularProgressIndicator());
          //   } else if (clientSnapshot.hasError) {
          //     return Center(
          //       child: Text('Ошибка клиента: ${clientSnapshot.error}'),
          //     );
          //   }

          //   final client = clientSnapshot.data;
          //   return Scaffold(
          //     appBar: CustomAppBar(title: 'Информация о услуге', actions: []),
          //     body: Padding(
          //       padding: const EdgeInsets.all(Dimens.padding16),
          //       child: Column(
          //         children: [
          //           CustomListTile(
          //             title: 'Создано:',
          //             subtitle: Text(
          //               DateFormat(
          //                 'd MMMM yyyy',
          //                 'ru_RU',
          //               ).format(session.createdAt),
          //             ),
          //           ),
          //           CustomListTile(
          //             onTap: () async {
          //               final controller =
          //                   Provider.of<CalculatorSessionController>(
          //                     context,
          //                     listen: false,
          //                   );
          //               if (client != null) {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (_) =>
          //                         ClientProfileScreen(client: client),
          //                   ),
          //                 );
          //               }
          //               if (client == null) {
          //                 final selectedClientId = await Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => const SelectClient(),
          //                   ),
          //                 );
          //                 if (selectedClientId != null) {
          //                   final updatedSession = session.copyWith(
          //                     clientId: selectedClientId,
          //                   );

          //                   await controller.update(updatedSession);

          //                   if (context.mounted) {
          //                     ScaffoldMessenger.of(context).showSnackBar(
          //                       SnackBar(
          //                         content: const Text("Сессия сохранена"),
          //                       ),
          //                     );

          //                     Navigator.pop(context);
          //                   }
          //                 }
          //               }
          //             },
          //             title: 'Клиент:',
          //             subtitle: Text(
          //               client?.name ?? 'Добавить клиента?',
          //               style: darkestTextStyle,
          //             ),
          //             divider: false,
          //           ),
          //           CustomListTile(title: 'До/После', divider: false),
          //           BeforeAfterUploader(
          //             session: session,
          //             controller: controller,
          //           ),

          //           SizedBox(height: Dimens.height24),
          //           CustomListTile(
          //             title: 'Затраченные Материалы:',
          //             divider: false,
          //           ),

          //           Expanded(
          //             child: ListView.builder(
          //               itemCount: session.consumptionData?.length ?? 0,
          //               itemBuilder: (context, index) {
          //                 final key = session.consumptionData!.keys.elementAt(
          //                   index,
          //                 );
          //                 final value = session.consumptionData!.values
          //                     .elementAt(index);

          //                 return CustomListTile(
          //                   trailing: Text(
          //                     "${value.toStringAsFixed(0)} ед.",
          //                     style: headingH5TextStyle,
          //                   ),
          //                   title: key,
          //                   subtitle: const Text("", style: darkestTextStyle),
          //                 );
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // },
        );
      },
    );
  }
}

class BeforeAfterImage extends StatefulWidget {
  final ImageProvider before;
  final ImageProvider after;

  const BeforeAfterImage({
    super.key,
    required this.before,
    required this.after,
  });

  @override
  State<BeforeAfterImage> createState() => _BeforeAfterImageState();
}

class _BeforeAfterImageState extends State<BeforeAfterImage> {
  double _dividerPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dividerPosition = (details.localPosition.dx / context.size!.width)
              .clamp(0.0, 1.0);
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.before,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              ClipPath(
                clipper: _AfterClipper(_dividerPosition),
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.after,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: constraints.maxWidth * _dividerPosition - 1.5,
                top: 0,
                bottom: 0,
                child: Container(width: 3, color: Colors.white),
              ),

              Positioned(
                left: constraints.maxWidth * _dividerPosition - 12,
                top: constraints.maxHeight / 2 - 12,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AfterClipper extends CustomClipper<Path> {
  final double position;

  _AfterClipper(this.position);

  @override
  Path getClip(Size size) {
    final dx = position * size.width;
    return Path()..addRect(Rect.fromLTRB(dx, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(_AfterClipper oldClipper) =>
      oldClipper.position != position;
}

class BeforeAfterUploader extends StatefulWidget {
  final CalculatorSession session;
  final CalculatorSessionController controller;

  const BeforeAfterUploader({
    super.key,
    required this.session,
    required this.controller,
  });

  @override
  State<BeforeAfterUploader> createState() => _BeforeAfterUploaderState();
}

class _BeforeAfterUploaderState extends State<BeforeAfterUploader> {
  File? before;
  File? after;

  @override
  void initState() {
    super.initState();
    if (widget.session.beforePhotos != null &&
        widget.session.beforePhotos!.isNotEmpty) {
      before = File(widget.session.beforePhotos!.last);
    }
    if (widget.session.afterPhotos != null &&
        widget.session.afterPhotos!.isNotEmpty) {
      after = File(widget.session.afterPhotos!.last);
    }
  }

  Future<void> _pickAndUploadImage(bool isBefore) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final file = File(picked.path);

    final updatedSession = await widget.controller.addPhoto(
      widget.session,
      isBefore,
      file,
    );

    if (updatedSession != null) {
      setState(() {
        if (isBefore && updatedSession.beforePhotos!.isNotEmpty) {
          before = File(updatedSession.beforePhotos!.last);
        } else if (!isBefore && updatedSession.afterPhotos!.isNotEmpty) {
          after = File(updatedSession.afterPhotos!.last);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (before == null || after == null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ImageBox(
                file: before,
                label: "До",
                onTap: () => _pickAndUploadImage(true),
              ),
              _ImageBox(
                file: after,
                label: "После",
                onTap: () => _pickAndUploadImage(false),
              ),
            ],
          ),
        const SizedBox(height: 20),
        if (before != null && after != null)
          SizedBox(
            height: 300,
            child: BeforeAfterImage(
              before: FileImage(before!),
              after: FileImage(after!),
            ),
          ),
      ],
    );
  }
}

class _ImageBox extends StatelessWidget {
  final File? file;
  final String label;
  final VoidCallback onTap;

  const _ImageBox({
    required this.file,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
          image: file != null
              ? DecorationImage(image: FileImage(file!), fit: BoxFit.cover)
              : null,
        ),
        child: file == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(label, style: TextStyle(color: Colors.grey.shade700)),
                ],
              )
            : null,
      ),
    );
  }
}
