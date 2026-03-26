import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralised logger for the Autozy app.
///
/// Usage:
///   AppLogger.debug('token set');
///   AppLogger.info('OTP sent', tag: 'Auth');
///   AppLogger.warning('Item not found in cache');
///   AppLogger.error('Login failed', error: e, stackTrace: st);
///
/// Logs are suppressed in release builds automatically.
class AppLogger {
  AppLogger._();

  static const String _defaultTag = 'Autozy';

  // ── public API ────────────────────────────────────────────────────────────

  static void debug(String message, {String? tag}) {
    _log(message, level: _Level.debug, tag: tag);
  }

  static void info(String message, {String? tag}) {
    _log(message, level: _Level.info, tag: tag);
  }

  static void warning(String message, {String? tag, Object? error}) {
    _log(message, level: _Level.warning, tag: tag, error: error);
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: _Level.error,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  // ── internals ─────────────────────────────────────────────────────────────

  static void _log(
    String message, {
    required _Level level,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final label = tag ?? _defaultTag;
    final prefix = level.prefix;

    developer.log(
      '$prefix $message',
      name: label,
      error: error,
      stackTrace: stackTrace,
      level: level.dartLevel,
    );
  }
}

enum _Level {
  debug(prefix: '[D]', dartLevel: 500),
  info(prefix: '[I]', dartLevel: 800),
  warning(prefix: '[W]', dartLevel: 900),
  error(prefix: '[E]', dartLevel: 1000);

  const _Level({required this.prefix, required this.dartLevel});
  final String prefix;
  final int dartLevel;
}
