//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/client/bloc/client_bloc.dart';
import 'package:tintly/features/client/bloc/client_state.dart';
import 'package:tintly/features/client/views/client_profile_screen.dart';
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
          return Center(child: CircularProgressIndicator());
        } else if (state is ClientError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is ClientLoaded) {
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final client = state.items[index];
              return Card(
                color: Colors.transparent,
                elevation: Dimens.elevation0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientProfileScreen(client: client),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: Dimens.height72,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Dimens.padding16,
                        right: Dimens.padding16,
                      ),
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

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import 'package:tintly/features/client/controllers/client_controller.dart';
// import 'package:tintly/features/client/views/client_profile_screen.dart';
// import 'package:tintly/shared/designs/dimens.dart';
// import 'package:tintly/shared/utils/size_utils.dart';
// import 'package:tintly/shared/widgets/choice_dialog.dart';
// import 'package:tintly/shared/widgets/client_card.dart';
// import 'package:tintly/shared/widgets/dialog/edit_dialog.dart';

// class ClientsListPage extends StatefulWidget {
//   final bool selectable;
//   final ValueChanged<String>? onClientSelected;

//   const ClientsListPage({
//     super.key,
//     this.selectable = false,
//     this.onClientSelected,
//   });

//   @override
//   State<ClientsListPage> createState() => _ClientsListPageState();
// }

// class _ClientsListPageState extends State<ClientsListPage> {
//   String? role;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       // await context.read<ClientController>().loadClients();
//       await _loadRole();
//     });
//   }

//   Future<void> _loadRole() async {
//     final box = await Hive.openBox('authBox');
//     setState(() {
//       role = box.get('role');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final controller = context.watch<ClientController>();

//     return Stack(
//       children: [
//         controller.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//                 padding: EdgeInsets.only(bottom: getListBottomPadding(context)),
//                 itemCount: controller.clients.length,
//                 itemBuilder: (context, index) {
//                   final client = controller.clients[index];
//                   return ClientCard(
//                     label: client.name,
//                     onTap: () {
//                       if (widget.selectable == false) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ClientProfileScreen(client: client),
//                           ),
//                         );
//                       } else {
//                         if (widget.onClientSelected != null) {
//                           widget.onClientSelected!(client.id);
//                         } else {
//                           Navigator.pop(context, client.id);
//                         }
//                       }
//                     },
//                     onDeleteTap: () async {
//                       bool? confirm = await showDialog<bool>(
//                         context: context,
//                         builder: (context) => ChoiceDialog(
//                           title: 'Удалить',
//                           description:
//                               'Вы уверены, что хотите Удалить данного клиента?',
//                           confirm: 'Удалить',
//                         ),
//                       );

//                       if (confirm == true) {
//                         await controller.delete(client);
//                       }
//                     },
//                     role: role,
//                     selectable: widget.selectable,
//                   );
//                 },
//               ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           left: 0,

//           child: Row(
//             children: [
//               Expanded(
//                 child: SearchBar(
//                   shape: WidgetStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(Dimens.radius10),
//                     ),
//                   ),
//                   backgroundColor: WidgetStateProperty.all(Color(0xFFF8F9FE)),
//                   elevation: WidgetStateProperty.all(0.1),
//                   hintText: 'Поиск...',
//                   leading: Padding(
//                     padding: const EdgeInsets.all(Dimens.padding16),
//                     child: Image.asset('assets/icons/search.png'),
//                   ),
//                   onChanged: (query) {
//                     context.read<ClientController>().filterClients(query);
//                   },
//                 ),
//               ),
//               SizedBox(width: Dimens.width16),
//               FloatingActionButton(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(Dimens.radius10),
//                 ),

//                 backgroundColor: Color(0xFFF8F9FE),
//                 elevation: Dimens.elevation006,
//                 child: Icon(Icons.add, color: Color(0xFF2F3036)),

//                 onPressed: () async {
//                   final result = await showDialog<String>(
//                     context: context,
//                     builder: (context) {
//                       return const EditDialog(
//                         label: 'Создать Клиента:',
//                         description: '',
//                         confirm: 'Создать',
//                         data: "",
//                       );
//                     },
//                   );
//                   if (result != null && result.isNotEmpty) {
//                     await controller.create(result);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
