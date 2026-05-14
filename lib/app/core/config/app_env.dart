import 'package:flutter/services.dart';

abstract final class AppEnv {
  static final Map<String, String> _values = <String, String>{};
  static bool _isLoaded = false;

  static Future<void> load() async {
    if (_isLoaded) {
      return;
    }

    try {
      final String raw = await rootBundle.loadString('.env');
      _values
        ..clear()
        ..addAll(_parse(raw));
    } catch (_) {
      _values.clear();
    }

    _isLoaded = true;
  }

  static String? maybeGet(String key) {
    final String? value = _values[key]?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  static Map<String, String> _parse(String raw) {
    final Map<String, String> parsed = <String, String>{};

    for (final String line in raw.split('\n')) {
      final String trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) {
        continue;
      }

      final int separatorIndex = trimmed.indexOf('=');
      if (separatorIndex <= 0) {
        continue;
      }

      final String key = trimmed.substring(0, separatorIndex).trim();
      if (key.isEmpty) {
        continue;
      }

      String value = trimmed.substring(separatorIndex + 1).trim();
      if (value.length >= 2) {
        final bool hasDoubleQuotes =
            value.startsWith('"') && value.endsWith('"');
        final bool hasSingleQuotes =
            value.startsWith("'") && value.endsWith("'");
        if (hasDoubleQuotes || hasSingleQuotes) {
          value = value.substring(1, value.length - 1);
        }
      }

      parsed[key] = value;
    }

    return parsed;
  }
}
