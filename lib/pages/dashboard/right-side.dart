import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schichtbuch_shift/global/index.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardRightSide extends StatelessWidget {
  // today's date

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        days(context),
        Row(
          children: [
            for (int i = 0; i < 7; i++) hours(context),
          ],
        )
      ],
    );
  }

  List<DateTime> getLastFiveDaysWithoutWeekend() {
    List<DateTime> businessDays = [];
    int daysToAdd = 0;
    while (businessDays.length < 7) {
      DateTime currentDate = DateTime.now().add(Duration(days: daysToAdd));
      if (currentDate.weekday != DateTime.saturday &&
          currentDate.weekday != DateTime.sunday) {
        businessDays.add(currentDate);
      }
      // businessDays.add(currentDate);
      daysToAdd++;
    }

    return businessDays;
  }

  Widget hours(context) {
    List<String> hours = ["00", "04", "08", "12", "16", "20"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...hours.map(
          (e) => Container(
            width: 63,
            height: 50,
            decoration: BoxDecoration(
              // border bottom
              border: Border(
                  bottom: BorderSide(
                    color: Color(0xff848484),
                    width: .5,
                  ),
                  right: BorderSide(
                    color: Color(0xff848484),
                    width: .5,
                  )),
            ),
            child: Center(
              child: Text(
                e,
                style: GoogleFonts.lexend(
                  fontSize: 22,
                  color: Color(0xff336699),
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget days(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (DateTime date in getLastFiveDaysWithoutWeekend())
              Container(
                width: 378,
                height: 50,
                decoration: BoxDecoration(
                  // border bottom
                  border: Border(
                      bottom: BorderSide(
                        color: Color(0xff848484),
                        width: .5,
                      ),
                      right: BorderSide(
                        color: Color(0xff848484),
                        width: .5,
                      )),
                ),
                child: Center(
                  child: Text(
                    weekdays[(date.weekday - 1)].toString() +
                        " " +
                        date.day.toString().padLeft(2, '0') +
                        " " +
                        monthNames[date.month - 1],
                    style: GoogleFonts.lexend(
                      fontSize: 22,
                      color: Color(0xff336699),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
          ]),
        )
      ],
    );
  }
}
