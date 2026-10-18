import 'package:intl/intl.dart';

extension DateTimeQatarX on DateTime {
  DateTime toQatarTime() {
    return toUtc().add(const Duration(hours: 3));
  }
}

String formatClassTimeRange(DateTime scheduledAt, String durationStr) {
  final localTime = scheduledAt.toQatarTime();

  // Parse duration
  int durationMinutes = 0;
  final lowerStr = durationStr.toLowerCase();
  int parsedValue = 0;
  final regex = RegExp(r'(\d+)');
  final match = regex.firstMatch(durationStr);
  if (match != null) {
    parsedValue = int.parse(match.group(1)!);
  }

  if (lowerStr.contains('hour') || lowerStr.contains('hr')) {
    durationMinutes = parsedValue * 60;
  } else if (lowerStr.contains('min')) {
    durationMinutes = parsedValue;
  } else {
    // Treat raw number as seconds for class
    durationMinutes = parsedValue ~/ 60;
  }

  final endTime = localTime.add(Duration(minutes: durationMinutes));

  final timeFormat = DateFormat('h:mm a');
  final startTimeStr = timeFormat.format(localTime);
  final endTimeStr = timeFormat.format(endTime);

  return '$startTimeStr - $endTimeStr';
}

String formatDuration(String durationStr, {bool isSeconds = false}) {
  if (durationStr.isEmpty) return '';

  // Check if it contains weeks, days, or months, which shouldn't be parsed as minutes.
  final lowerStr = durationStr.toLowerCase();
  if (lowerStr.contains('week') ||
      lowerStr.contains('day') ||
      lowerStr.contains('month')) {
    return durationStr;
  }

  // Parse numeric value
  int parsedValue = 0;
  final regex = RegExp(r'(\d+)');
  final match = regex.firstMatch(durationStr);
  if (match != null) {
    parsedValue = int.parse(match.group(1)!);
  }

  if (parsedValue <= 0) {
    return durationStr.isNotEmpty ? durationStr : '0 Mins';
  }

  int durationMinutes = 0;
  if (lowerStr.contains('hour') || lowerStr.contains('hr')) {
    durationMinutes = parsedValue * 60;
  } else if (lowerStr.contains('min')) {
    durationMinutes = parsedValue;
  } else {
    // Raw number: check if we should parse as seconds (for Class) or minutes (for Course)
    if (isSeconds) {
      durationMinutes = parsedValue ~/ 60;
    } else {
      durationMinutes = parsedValue;
    }
  }

  if (durationMinutes <= 0) {
    return durationStr;
  }

  final hours = durationMinutes ~/ 60;
  final minutes = durationMinutes % 60;

  if (hours > 0) {
    final hourLabel = hours == 1 ? 'Hour' : 'Hours';
    if (minutes > 0) {
      return '$hours $hourLabel $minutes Mins';
    } else {
      return '$hours $hourLabel';
    }
  } else {
    return '$minutes Mins';
  }
}
