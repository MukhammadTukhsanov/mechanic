// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalCupertinoPicker extends StatefulWidget {
  String? label = '';

  int selectedDate = 1;
  double? labelFontSize;

  bool? hours = false;

  bool? error;

  Function(int)? onSelect;
  Function(TimeOfDay)? onSetHour;
  ModalCupertinoPicker(
      {this.label,
      this.hours,
      this.labelFontSize,
      this.selectedDate = 0,
      this.onSelect,
      this.onSetHour,
      this.error = false});
  @override
  State<ModalCupertinoPicker> createState() => _ModalCupertinoPickerState();
}

class _ModalCupertinoPickerState extends State<ModalCupertinoPicker> {
  // int selectedDate = 1;
  String selectedHours =
      "00 ${S.current.hours[0]} - 00 ${S.current.minutes[0]}";
  bool days = true;

  @override
  Widget build(BuildContext context) {
    days = widget.hours == true ? false : true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label == null
            ? SizedBox(height: 0)
            : Text(
                widget.label!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xff336699),
                  fontSize:
                      widget.labelFontSize == null ? 22 : widget.labelFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
        widget.label == '' ? SizedBox(height: 0) : SizedBox(height: 10),
        Container(
          height: 61,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.error! ? Color(0xffcc0000) : Color(0xff848484),
              width: .5,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
                primaryColor: Colors.cyan,
                buttonTheme: ButtonTheme.of(context).copyWith(
                    colorScheme: ColorScheme.light(secondary: Colors.cyan))),
            child: TextButton(
              onPressed: days
                  ? () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: builderPicker(),
                          );
                        },
                      );
                    }
                  : () async {
                      final TimeOfDay? picked = await showTimePicker(
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        context: context,
                        orientation: Orientation.portrait,
                        initialTime: selectedHours ==
                                "00 ${S.of(context).hours[0]} - 00 ${S.of(context).minutes[0]}"
                            ? TimeOfDay(hour: 0, minute: 0)
                            : TimeOfDay(
                                hour: int.parse(selectedHours.split(" ")[0]),
                                minute: int.parse(selectedHours.split(" ")[3]),
                              ),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xff336699),
                              ),
                            ),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            ),
                          );
                        },
                      );
                      if (picked != null) {
                        widget.onSetHour!(picked);
                        setState(() {
                          selectedHours =
                              "${picked.hour} ${S.of(context).hours[0]} - ${picked.minute} ${S.of(context).minutes[0]}";
                        });
                      }
                    },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    days
                        ? "${widget.selectedDate} ${S.of(context).days}"
                        : selectedHours,
                    style: GoogleFonts.lexend(
                      textStyle: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget builderPicker() => Container(
        height: 300,
        child: CupertinoPicker(
          itemExtent: 64,
          scrollController:
              FixedExtentScrollController(initialItem: widget.selectedDate),
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xff848484),
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Color(0xff848484),
                  width: 0.5,
                ),
              ),
            ),
          ),
          onSelectedItemChanged: (int index) {
            widget.onSelect!(index);
          },
          children: [
            for (int i = 0; i <= 60; i++)
              Center(
                key: ValueKey<int>(i),
                child: Text(
                  "$i ${S.of(context).days}",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
          ],
        ),
      );
}
