// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalCupertinoPicker extends StatefulWidget {
  String? label = '12';

  int selectedDate = 1;
  double? labelFontSize;

  bool? hours = false;

  bool? error;

  int? defaultHours;
  int? defaultMinutes;
  int? defaultIndex;

  Function(int)? onSelect;
  Function? onSetHour;
  ModalCupertinoPicker(
      {this.label,
      this.defaultHours,
      this.defaultMinutes,
      this.hours,
      this.labelFontSize,
      this.selectedDate = 0,
      this.onSelect,
      this.onSetHour,
      this.defaultIndex,
      this.error = false});
  @override
  State<ModalCupertinoPicker> createState() => _ModalCupertinoPickerState();
}

class _ModalCupertinoPickerState extends State<ModalCupertinoPicker> {
  TextEditingController selectedHoursController = TextEditingController();
  TextEditingController selectedMinutesController = TextEditingController();
  // int selectedDate = 1;
  String selectedHours =
      "00 ${S.current.hours[0]} - 00 ${S.current.minutes[0]}";
  bool days = true;

  // Initial load
  @override
  void initState() {
    super.initState();
    // selectedHours = "${widget.defaultHours} - ${widget.defaultMinutes}";
  }

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
                  : () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Color.fromRGBO(244, 254, 255, 1),
                          title: Text(S.of(context).enterTime,
                              style: TextStyle(
                                  color: Color(0xff848484), fontSize: 22)),
                          content: Container(
                            height: 110,
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                    controller: selectedHoursController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 32),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.all(0.0),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffffffff))),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '---',
                                      hintStyle: TextStyle(
                                        fontSize: 44,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 3,
                                  )),
                                  SizedBox(
                                    width: 20,
                                    height: 62,
                                    child: Center(
                                        child: Text(
                                      ":",
                                      style: TextStyle(fontSize: 32),
                                    )),
                                  ),
                                  Expanded(
                                      child: TextField(
                                    controller: selectedMinutesController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 32),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.all(0.0),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffffffff))),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '--',
                                      hintStyle: TextStyle(
                                        fontSize: 44,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 2,
                                  )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(S.of(context).hour,
                                        style: TextStyle(
                                            color: Color(0xff848484),
                                            fontSize: 16)),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(S.of(context).minute,
                                        style: TextStyle(
                                            color: Color(0xff848484),
                                            fontSize: 16)),
                                  ),
                                ],
                              )
                            ]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text(S.of(context).cancel,
                                  style: TextStyle(
                                      color: Color(0xff336699), fontSize: 18)),
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedHours =
                                        "${selectedHoursController.text.isEmpty ? selectedHoursController.text = "00" : selectedHoursController.text} ${S.of(context).hours[0]} - ${selectedMinutesController.text.isEmpty ? selectedMinutesController.text = "00" : selectedMinutesController.text} ${S.of(context).minutes[0]}";
                                  });
                                  widget.onSetHour!({
                                    "hours": double.parse(
                                            selectedHoursController.text)
                                        .round(),
                                    "minutes": double.parse(
                                            selectedMinutesController.text)
                                        .round()
                                  });
                                  Navigator.pop(context, 'OK');
                                },
                                child: Text('OK',
                                    style: TextStyle(
                                        color: Color(0xff336699),
                                        fontSize: 18))),
                          ],
                        ),
                      ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    days
                        ? "${widget.selectedDate} ${S.of(context).days}"
                        : selectedHours,
                    style: GoogleFonts.roboto(
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
