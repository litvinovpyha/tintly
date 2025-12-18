//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/client/bloc/client_bloc.dart';
import 'package:tintly/features/client/bloc/client_event.dart';
import 'package:tintly/features/client/bloc/client_state.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';

class ClientList extends StatelessWidget {
  const ClientList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is ClientLoading) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is ClientError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is ClientLoaded) {
          return ListView.builder(
            itemCount: state.clients.length,
            itemBuilder: (context, index) {
              final client = state.clients[index];
              return Card(
                color: Colors.transparent,
                elevation: Dimens.elevation0,
                child: InkWell(
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/client/profile',
                      arguments: client.id,
                    );

                    if (context.mounted) {
                      context.read<ClientBloc>().add(LoadClients());
                    }
                  },
                  child: SizedBox(
                    height: Dimens.height72,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: Dimens.padding16,
                          ),
                          child: SizedBox(
                            height: Dimens.height40,
                            width: Dimens.width40,
                            child: Image.asset(
                              client.photo ?? 'assets/images/avatar.png',
                            ),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            client.name,
                            style: headingH5TextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        chevronRight,
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is ClientError) {
          return Text('Ошибка: ${state.message}');
        }
        return Container();
      },
    );
  }
}
