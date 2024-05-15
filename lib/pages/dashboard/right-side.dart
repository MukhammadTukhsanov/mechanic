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
            for (int i = 0; i < 5; i++) hours(context),
          ],
        )
      ],
    );
  }

  List<DateTime> getLastFiveDaysWithoutWeekend() {
    List<DateTime> result = [];
    DateTime today = DateTime.now();

    // Start from yesterday
    DateTime date = today.subtract(Duration(days: 1));

    while (result.length < 5) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        result.add(date);
      }
      date = date.subtract(Duration(days: 1));
    }
    return result;
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
            height: 50.5,
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
                height: 51.5,
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
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: Center(
                  child: Text(
                    date.day.toString().padLeft(2, '0') +
                        " " +
                        monthNames[date.month - 1] +
                        " " +
                        date.year.toString(),
                    style: GoogleFonts.lexend(
                      fontSize: 22,
                      color: Color(0xff336699),
                      fontWeight: FontWeight.w200,
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
