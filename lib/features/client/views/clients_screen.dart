import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/client/bloc/client_bloc.dart';
import 'package:tintly/features/client/bloc/client_event.dart';
import 'package:tintly/features/client/repositories/client_repository.dart';
import 'package:tintly/features/client/views/client_list.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/dialog/edit_dialog.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientBloc(ClientRepository())..add(LoadClients()),
      child: Builder(
        builder: (context) {
          return Stack(
            children: [
              const ClientList(),

              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Dimens.radius10,
                            ),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Color(0xFFF8F9FE),
                        ),
                        elevation: WidgetStateProperty.all(0.1),
                        hintText: 'Поиск...',
                        leading: Padding(
                          padding: const EdgeInsets.all(Dimens.padding16),
                          child: Image.asset('assets/icons/search.png'),
                        ),
                        onChanged: (query) {
                          context.read<ClientBloc>().add(FilterClients(query));
                        },
                      ),
                    ),
                    SizedBox(width: Dimens.width16),
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius10),
                      ),
                      backgroundColor: Color(0xFFF8F9FE),
                      elevation: Dimens.elevation006,
                      child: Icon(Icons.add, color: Color(0xFF2F3036)),
                      onPressed: () async {
                        final name = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return const EditDialog(
                              label: 'Создать Клиента:',
                              description: '',
                              confirm: 'Создать',
                              data: "",
                            );
                          },
                        );
                        if (name != null && name.isNotEmpty) {
                          context.read<ClientBloc>().add(
                            CreateClientRequested(name),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
