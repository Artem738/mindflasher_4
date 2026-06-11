import 'package:flutter/foundation.dart';

enum AppLogLevel {
  debug,
  info,
  warning,
  error,
}

class AppLogEntry {
  const AppLogEntry({
    required this.timestamp,
    required this.level,
    required this.scope,
    required this.message,
  });

  final DateTime timestamp;
  final AppLogLevel level;
  final String scope;
  final String message;

  String format() {
    final hh = timestamp.hour.toString().padLeft(2, '0');
    final mm = timestamp.minute.toString().padLeft(2, '0');
    final ss = timestamp.second.toString().padLeft(2, '0');
    return '[$hh:$mm:$ss] ${level.name.toUpperCase()} [$scope] $message';
  }
}

class AppLogger extends ChangeNotifier {
  AppLogger._();

  static final AppLogger instance = AppLogger._();
  static const int _maxEntries = 300;

  final List<AppLogEntry> _entries = <AppLogEntry>[];

  List<AppLogEntry> get entries => List<AppLogEntry>.unmodifiable(_entries);

  void debug(String scope, String message) => _log(AppLogLevel.debug, scope, message);

  void info(String scope, String message) => _log(AppLogLevel.info, scope, message);

  void warning(String scope, String message) => _log(AppLogLevel.warning, scope, message);

  void error(String scope, String message) => _log(AppLogLevel.error, scope, message);

  void clear() {
    _entries.clear();
    notifyListeners();
  }

  void _log(AppLogLevel level, String scope, String message) {
    final entry = AppLogEntry(
      timestamp: DateTime.now(),
      level: level,
      scope: scope,
      message: message,
    );
    _entries.add(entry);
    if (_entries.length > _maxEntries) {
      _entries.removeAt(0);
    }
    debugPrint(entry.format());
    notifyListeners();
  }
}