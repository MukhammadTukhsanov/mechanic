import 'package:schichtbuch_shift/generated/l10n.dart';

String key = '';
// String key = '';
String user = '';
String ipAdress = '192.168.100.23:7878';
// String ipAdress = '34.31.212.138';
var globalDevices = [
  "Emac50-1333",
  "E 35-1",
  "E45-1",
  "E45-2",
  "F 450iA-1",
  "E50-2",
  "E50-3",
  "F 150iA-1",
  "EM 50-1",
  "EM 50-2",
  "EM 50-3",
  "KM 50-1",
  "KM 80-1",
  "KM 150-1",
  "EM 55-1",
  "KM 420-1",
  "E 120-1",
  "E 80-1",
  "F 250iA-1",
];

final monthNames = [
  S.current.january,
  S.current.february,
  S.current.march,
  S.current.april,
  S.current.may,
  S.current.june,
  S.current.july,
  S.current.august,
  S.current.september,
  S.current.october,
  S.current.november,
  S.current.december
];

DateTime addMinutes(DateTime date, int minutes) {
  const int millisecondsPerMinute = 60000;
  int updatedTime =
      date.millisecondsSinceEpoch + minutes * millisecondsPerMinute;
  DateTime newDate = DateTime.fromMillisecondsSinceEpoch(updatedTime);

  // Function to check if a date is on a weekend
  bool isWeekend(DateTime d) {
    int day = d.weekday;
    return day == DateTime.saturday || day == DateTime.sunday;
  }

  // If the new date is on a weekend, move to the next Monday
  while (isWeekend(newDate)) {
    newDate = newDate.add(Duration(days: 1));
    newDate = DateTime(newDate.year, newDate.month, newDate.day);
  }

  return newDate;
}

bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  return now.day == date.day &&
      now.month == date.month &&
      now.year == date.year;
}

int calculateWeekdays(DateTime start, DateTime end) {
  int weekdays = 0;
  DateTime current = start;

  while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
    if (current.weekday != DateTime.saturday &&
        current.weekday != DateTime.sunday) {
      weekdays++;
    }
    current = current.add(Duration(days: 1));
  }
  weekdays == 0 ? weekdays : weekdays - 1;
  print("weekdays: $weekdays");
  return weekdays;
}
