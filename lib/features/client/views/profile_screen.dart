import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/client/bloc/client_bloc.dart';
import 'package:tintly/features/client/bloc/client_event.dart';
import 'package:tintly/features/client/bloc/client_state.dart';
import 'package:tintly/features/client/repository/client_repository.dart';
import 'package:tintly/features/client/views/profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? clientId =
        ModalRoute.of(context)?.settings.arguments is String
        ? ModalRoute.of(context)!.settings.arguments as String
        : null;

    if (clientId == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: Клиент не предоставлен.')),
      );
    }
    return BlocProvider(
      create: (context) =>
          ClientBloc(ClientRepository())..add(LoadClient(clientId)),
      child: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientDeleted) {
            Navigator.pop(context);
            context.read<ClientBloc>().add(LoadClients());
          }
        },
        child: ProfileView(),
      ),
    );
  }
}
