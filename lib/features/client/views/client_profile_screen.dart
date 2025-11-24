import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tintly/features/client/models/client.dart';
import 'package:tintly/features/admin/controllers/calculator_session_controller.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key, required this.client});
  final Client client;
  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  late final CalculatorSessionController sessionController;
  List<CalculatorSession> clientSessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    sessionController = Provider.of<CalculatorSessionController>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sessions = await sessionController.getSessionsByClientId(
        widget.client.id,
      );

      setState(() {
        clientSessions = sessions;
        isLoading = false;
      });
    });
  }

  Future<void> openInstagram(String username) async {
    final Uri url = Uri.parse('https://www.instagram.com/$username/');
    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Не удалось открыть Instagram';
    }
  }

  Future<void> openWhatsApp(String phone) async {
    final Uri url = Uri.parse('https://wa.me/$phone');
    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Не удалось открыть Instagram';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final bookedDates = clientSessions
        .map(
          (s) => DateTime(s.createdAt.year, s.createdAt.month, s.createdAt.day),
        )
        .toSet();

    return Scaffold(
      appBar: CustomAppBar(title: widget.client.name, actions: []),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: widget.client.photo != null
                      ? AssetImage(widget.client.photo!)
                      : const AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(width: 12),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        
                      
                      },
                      onLongPress: () async {
                        
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.chat),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        
                      },
                      onLongPress: () async {
                       
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.pink.shade100,
                        child: Image.asset(
                          'assets/icons/instagram.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              widget.client.name,
              style: titleTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 24),

          TableCalendar(
            locale: 'ru_Ru',
            focusedDay: DateTime.now(),
            firstDay: DateTime(2025),
            lastDay: DateTime(2027),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'неделя'},
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isBooked = bookedDates.contains(
                  DateTime(day.year, day.month, day.day),
                );
                return Center(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.red.withValues(alpha: 0.7)
                            : null,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: InkWell(
                        onTap: () {
                          if (isBooked) {
                            final session = clientSessions.firstWhere(
                              (s) =>
                                  s.createdAt.year == day.year &&
                                  s.createdAt.month == day.month &&
                                  s.createdAt.day == day.day,
                              orElse: () => clientSessions.first,
                            );

                            Navigator.pushNamed(
                              context,
                              '/history/feature-screen',
                              arguments: session.id,
                            );
                          }
                        },
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isBooked ? Colors.white : Colors.black,
                            fontWeight: isBooked
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          CustomListTile(
            title: 'Телефон',
            subtitle: Text(
              widget.client.phone ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              child: Icon(Icons.edit),
              onTap: () async {
             

              
              },
            ),
          ),
          CustomListTile(
            title: 'День рождения',
            subtitle: Text(
              widget.client.birthday ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              child: Icon(Icons.edit),
              onTap: () async {
               
              },
            ),
          ),
          CustomListTile(
            title: 'Комментарий',
            subtitle: Text(
              widget.client.comment ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              child: Icon(Icons.edit),
              onTap: () async {
               
              },
            ),
          ),
          CustomListTile(
            title: 'Техника окрашивания',
            subtitle: Text(
              widget.client.coloringTechnique ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              child: Icon(Icons.edit),
              onTap: () async {
               
              },
            ),
          ),
          CustomListTile(
            title: 'Тип стрижки',
            subtitle: Text(
              widget.client.haircutType ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              child: Icon(Icons.edit),
              onTap: () async {
               
              },
            ),
          ),
          CustomListTile(
            title: 'Длительность услуги',
            subtitle: Text(
              widget.client.serviceDuration ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              child: Icon(Icons.edit),
              onTap: () async {
              
              },
            ),
          ),
        ],
      ),
    );
  }
}
