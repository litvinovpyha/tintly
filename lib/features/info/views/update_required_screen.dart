// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class UpdateRequiredScreen extends StatelessWidget {
//   const UpdateRequiredScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.system_update, size: 90, color: Colors.blue),
//               const SizedBox(height: 20),
//               const Text(
//                 'Доступна новая версия',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Пожалуйста, обновите приложение, чтобы продолжить работу.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () async {
//                   final url = Uri.parse('https://t.me/yourlink_or_store_url');
//                   if (await canLaunchUrl(url)) {
//                     await launchUrl(url, mode: LaunchMode.externalApplication);
//                   }
//                 },
//                 child: const Text('Обновить сейчас'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
