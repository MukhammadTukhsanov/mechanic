import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schichtbuch_shift/components/switch.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';

class machineQualityItem extends StatefulWidget {
  final String machineQrCode;
  final String partnumber;
  final String partname;
  bool allPartStatusOK = false;
  machineQualityItem(
      {required this.machineQrCode,
      required this.partnumber,
      required this.partname,
      required this.allPartStatusOK});

  @override
  State<machineQualityItem> createState() => _machineQualityItemState();
}

class _machineQualityItemState extends State<machineQualityItem> {
  bool _partStatusOK = false;

  void changeFunction() {
    setState(() {
      _partStatusOK = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allPartStatusOK) {
      changeFunction();
    }
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: Color(0xff336699).withOpacity(.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  border: BorderDirectional(
                      end: BorderSide(
                          color: Color(0xff336699).withOpacity(.3), width: 1),
                      start: BorderSide(
                          color: Color(0xff336699).withOpacity(.3), width: 1))),
              child: Center(
                child: Text(
                  widget.machineQrCode,
                  style: GoogleFonts.lexend(
                      color: Color(0xff336699), fontSize: 24),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: BorderDirectional(
                      end: BorderSide(
                          color: Color(0xff336699).withOpacity(.3), width: 1))),
              child: Center(
                child: Text(
                  widget.partnumber,
                  style: GoogleFonts.lexend(
                      color: Color(0xff336699), fontSize: 24),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: BorderDirectional(
                      end: BorderSide(
                          color: Color(0xff336699).withOpacity(.3), width: 1))),
              child: Center(
                child: Text(
                  widget.partname,
                  style: GoogleFonts.lexend(
                      color: Color(0xff336699), fontSize: 24),
                ),
              ),
            ),
          ),
          Expanded(
              child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (allOk) {
                    print("its true");
                    setState(() {
                      allOk = false;
                    });
                  }
                  _partStatusOK = !_partStatusOK;
                });
              },
              child: Container(
                width: 55,
                height: 25,
                decoration: BoxDecoration(
                  color: _partStatusOK || widget.allPartStatusOK
                      ? Color(0xff336699)
                      : Color(0xff848484),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Color(0xff848484),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).yes,
                                style: GoogleFonts.lexend(
                                  textStyle: TextStyle(
                                      color: _partStatusOK
                                          ? Colors.white
                                          : Colors.transparent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )),
                            Text(S.of(context).no,
                                style: GoogleFonts.lexend(
                                    textStyle: TextStyle(
                                        color: _partStatusOK
                                            ? Colors.transparent
                                            : Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: _partStatusOK
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 21.5,
                          height: 21.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
