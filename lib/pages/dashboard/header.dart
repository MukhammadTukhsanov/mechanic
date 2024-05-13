import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: 450,
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
                  // Today's date with format: 2021-10-01
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
              // Spacer
              Spacer(),
              // actual time
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
        ),
      ],
    );
  }
}
