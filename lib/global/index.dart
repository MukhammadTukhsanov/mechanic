import 'package:schichtbuch_shift/generated/l10n.dart';

String key = '';
// String key = '';
// 04711227280
String user = '';
String ipAdress = '192.168.100.23:7878';
// String ipAdress = '104.198.75.202';
// String ipAdress = '127.0.0.1:8000';
int count = 0;
bool showAlert = false;
var globalDevices = [];

bool allOk = false;

var shiftText = S.current.toolCleaningShiftF1Done;
var lastShift = "";
// var shiftText = "false";
// var lastShift = "F1";

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

final weekdays = [
  S.current.monday,
  S.current.tuesday,
  S.current.wednesday,
  S.current.thursday,
  S.current.friday,
  S.current.saturday,
  S.current.sunday,
];

bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  return now.day == date.day &&
      now.month == date.month &&
      now.year == date.year;
}

int newCalculateDaysExcludingWeekends(DateTime start, DateTime end) {
  print("start: $start");
  print("end: $end");

  // Set the end date time to midnight
  end = DateTime(end.year, end.month, end.day);

  // Calculate total time difference in milliseconds
  final totalMilliseconds = end.difference(start).inMilliseconds;

  // Convert to hours and minutes
  final totalMinutes = (totalMilliseconds / (1000 * 60)).floor();

  // Create a counter to keep track of weekend days (0 = Sunday, 6 = Saturday)
  int weekendDays = 0;
  DateTime currentDate = start;

  // Loop through each day in the range
  while (currentDate.isBefore(end)) {
    final dayOfWeek = currentDate.weekday;
    if (dayOfWeek == DateTime.saturday || dayOfWeek == DateTime.sunday) {
      weekendDays++;
    }
    currentDate = currentDate.add(Duration(days: 1));
  }

  // Calculate effective time excluding weekends
  final effectiveTotalMinutes = totalMinutes - (weekendDays * 24 * 60);
  final effectiveHours = (effectiveTotalMinutes / 60).floor();

  // print(
  //     "Days: ${effectiveHours ~/ 24}, hours: ${effectiveHours % 24}, effectiveMinutes: $effectiveMinutes");

  print("effectiveHours: $effectiveHours");
  return effectiveHours;

  // Uncomment the following if you want to return an object
  // return {
  //   'days': effectiveHours ~/ 24,
  //   'hours': effectiveHours % 24,
  //   'minutes': effectiveMinutes
  // };
}

DateTime addTimeSkippingWeekends(
    DateTime startDate, int daysToAdd, int minutesToAdd) {
  int totalMinutes = daysToAdd * 24 * 60 + minutesToAdd;
  int remainingMinutes = totalMinutes;
  DateTime currentDate = startDate;

  while (remainingMinutes > 0) {
    currentDate = currentDate.add(Duration(minutes: 1));

    // Skip weekends
    // if (currentDate.weekday == DateTime.saturday ||
    //     currentDate.weekday == DateTime.sunday) {
    //   continue;
    // }

    remainingMinutes--;
  }
  print("currentDate: $currentDate");

  return currentDate;
}
