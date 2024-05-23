import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardLeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(context),
        status(context),
      ],
    );
  }

  Widget status(context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff848484),
            width: .5,
          ),
          right: BorderSide(
            color: Color(0xff848484),
            width: .5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  child: Center(
                      child: Text(S.of(context).machine,
                          style: GoogleFonts.lexend(
                              fontSize: 19,
                              color: Color(0xff336699),
                              fontWeight: FontWeight.w500))))),
          Container(
              width: 100,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Color(0xff848484),
                    width: .5,
                  ),
                  right: BorderSide(
                    color: Color(0xff848484),
                    width: .5,
                  ),
                ),
              ),
              child: Center(
                  child: Text(S.of(context).status,
                      style: GoogleFonts.lexend(
                          fontSize: 19,
                          color: Color(0xff336699),
                          fontWeight: FontWeight.w500)))),
          Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(S.of(context).ProductNo,
                          style: GoogleFonts.lexend(
                              fontSize: 19,
                              color: Color(0xff336699),
                              fontWeight: FontWeight.w500))))),
        ],
      ),
    );
  }

  Widget header(context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
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
          ),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                "${S.of(context).today}:",
                style: GoogleFonts.lexend(
                  color: Color(0xff336699),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              Text(
                  DateTime.now().day.toString().padLeft(2, '0') +
                      " " +
                      monthNames[DateTime.now().month - 1] +
                      " " +
                      DateTime.now().year.toString(),
                  style: GoogleFonts.lexend(
                    color: Color(0xff336699),
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  ))
            ],
          ),
          Spacer(),
          Text(
            DateTime.now().hour.toString().padLeft(2, '0') +
                ":" +
                DateTime.now().minute.toString().padLeft(2, '0'),
            style: GoogleFonts.lexend(
              color: Color(0xff336699),
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
