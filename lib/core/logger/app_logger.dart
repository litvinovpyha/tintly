// lib/core/logger/app_logger.dart
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  static const String _tag = 'Tintly';

  static void debug(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag);
  }

  static void info(String message, [String? tag]) {
    _log(LogLevel.info, message, tag);
  }

  static void warning(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag);
  }

  static void error(
    String message, [
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log(LogLevel.error, message, tag, error, stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, [
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final levelStr = level.name.toUpperCase();
      final tagStr = tag != null ? '[$tag]' : '[$_tag]';

      final logMessage = '$timestamp $levelStr $tagStr: $message';

      switch (level) {
        case LogLevel.debug:
          debugPrint(logMessage);
          break;
        case LogLevel.info:
          debugPrint(logMessage);
          break;
        case LogLevel.warning:
          debugPrint('⚠️ $logMessage');
          break;
        case LogLevel.error:
          debugPrint('❌ $logMessage');
          if (error != null) {
            debugPrint('Error: $error');
          }
          if (stackTrace != null) {
            debugPrint('Stack trace: $stackTrace');
          }
          break;
      }
    }
  }
}
