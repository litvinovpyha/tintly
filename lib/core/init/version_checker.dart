// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:package_info_plus/package_info_plus.dart'; 

// class VersionChecker {
//   static const String apiUrl = 'http://nikaeva.kz/tintly/api/1.1/appconfig/version';

//   static Future<bool> needsUpdate() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode != 200) return false;

//       final data = jsonDecode(response.body);
//       final serverVersion = data['version'] as String;

//       final packageInfo = await PackageInfo.fromPlatform();
//       final currentVersion = packageInfo.version;

//       return _isOlderVersion(currentVersion, serverVersion);
//     } catch (e) {
//   return true;
//     }
//   }

//   static bool _isOlderVersion(String current, String latest) {
//     List<int> cv = current.split('.').map(int.parse).toList();
//     List<int> lv = latest.split('.').map(int.parse).toList();

//     for (int i = 0; i < lv.length; i++) {
//       if (i >= cv.length) return true; 
//       if (cv[i] < lv[i]) return true;
//       if (cv[i] > lv[i]) return false;
//     }
//     return false;
//   }
// }
