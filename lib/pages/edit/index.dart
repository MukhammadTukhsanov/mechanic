import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/components/button.dart';
import 'package:flutter_nfc_kit_example/components/cupertino-picker.dart';
import 'package:flutter_nfc_kit_example/components/input.dart';
import 'package:flutter_nfc_kit_example/components/switch.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPage extends StatefulWidget {
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool toolMounted = true;
  bool machineStopped = false;
  bool partStatus = true;

  TextEditingController userController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController _machineIdController = TextEditingController();
  TextEditingController _productionNumberController = TextEditingController();
  TextEditingController _partNameController = TextEditingController();
  TextEditingController _partNumberController = TextEditingController();
  TextEditingController _cavityController = TextEditingController();
  TextEditingController _numberOfPiecesAcumulatedController =
      TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController remainingController = TextEditingController();

  String radioValue = "yes";

  int remainingHours = 0;
  int remainingMinute = 0;
  int operatingHours = 0;
  int operatingMinute = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
                title: Text(S.of(context).modifyExistingEntries,
                    style: TextStyle(
                        color: Color(0xff336699),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                leading: Builder(builder: (BuildContext context) {
                  return IconButton(
                      icon:
                          Icon(Icons.menu, color: Color(0xff336699), size: 30),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip);
                }),
                actions: [
                  Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff848484), width: 0.5),
                          borderRadius: BorderRadius.circular(5.0)),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      child: Row(children: [
                        Icon(Icons.person_outline,
                            color: Color(0xff336699), size: 30),
                        SizedBox(width: 10.0),
                        Text(S.of(context).user,
                            style: TextStyle(
                                color: Color(0xff336699), fontSize: 20))
                      ])),
                  SizedBox(width: 40.0),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          icon: Icon(Icons.logout,
                              color: Colors.red, size: 30.0)))
                ],
                centerTitle: true,
                flexibleSpace: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(30, 5, 119, 190),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(0, 3))
                ]))),
            body: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(children: [
                          Input(
                              label: S.of(context).user,
                              labelText: "User",
                              disabled: true,
                              controller: userController),
                          SizedBox(height: 20.0),
                          Row(children: [
                            SwitchWithText(
                                label: S.of(context).toolMounted,
                                value: toolMounted,
                                onChange: () {
                                  setState(() {
                                    toolMounted = !toolMounted;
                                  });
                                }),
                            SizedBox(width: 80),
                            SwitchWithText(
                                value: machineStopped,
                                label: S.of(context).machineStopped,
                                onChange: () {
                                  setState(() {
                                    machineStopped = !machineStopped;
                                  });
                                })
                          ]),
                          SizedBox(height: 20.0),
                          Row(children: [
                            Expanded(
                                child: Input(
                                    label: S.of(context).date,
                                    labelText: "07/11/2023",
                                    disabled: true,
                                    controller: dateController)),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: Input(
                                    label: S.of(context).time,
                                    labelText: "12 : 34",
                                    disabled: true,
                                    controller: timeController))
                          ]),
                          SizedBox(height: 20.0),
                          Input(
                              label: S.of(context).shift,
                              disabled: true,
                              labelText: "N3",
                              controller: shiftController),
                          SizedBox(height: 20.0),
                          Input(
                              controller: _machineIdController,
                              label: "Machine ID",
                              labelText: "- - -"),
                          SizedBox(height: 20.0),
                          Row(children: [
                            Expanded(
                                child: Input(
                                    label: S.of(context).productionNumber,
                                    labelText: S.of(context).productionNumber,
                                    controller: _productionNumberController)),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: Input(
                                    label: S.of(context).partName,
                                    labelText: S.of(context).partName,
                                    controller: _partNameController))
                          ]),
                          SizedBox(height: 20.0),
                          Input(
                              label: S.of(context).partNumber,
                              labelText: S.of(context).partNumber,
                              controller: _partNumberController),
                          SizedBox(height: 20.0),
                          Input(
                              label: S.of(context).cavity,
                              labelText: S.of(context).cavity,
                              keyboardType: TextInputType.number,
                              controller: _cavityController),
                          SizedBox(height: 20.0),
                          SwitchWithText(
                              label: S.of(context).partStatusOk,
                              value: partStatus,
                              onChange: () {
                                setState(() {
                                  partStatus = !partStatus;
                                });
                              }),
                          SizedBox(height: 20.0),
                          Input(
                              label: S.of(context).numberOfPiecesAcumulated,
                              labelText: "52",
                              controller: _numberOfPiecesAcumulatedController),
                          SizedBox(height: 20.0),
                          Input(
                              label: S.of(context).note,
                              labelText: S.of(context).note,
                              controller: _noteController),
                          SizedBox(height: 20.0),
                          Column(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(S.of(context).toolCleaningShiftF1Done,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff336699),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Transform.scale(
                                        scale: 1.5,
                                        child: Radio(
                                            value: "yes",
                                            groupValue: radioValue,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Color(0xff336699)),
                                            onChanged: (value) {
                                              setState(() {
                                                radioValue = value as String;
                                              });
                                            })),
                                    Text(S.of(context).yes,
                                        style: GoogleFonts.lexend(
                                            textStyle: TextStyle(
                                                color: Color(0xff336699),
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400)))
                                  ]),
                                  Row(children: [
                                    Transform.scale(
                                        scale: 1.5,
                                        child: Radio(
                                            value: "no",
                                            groupValue: radioValue,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Color(0xff336699)),
                                            onChanged: (value) {
                                              setState(() {
                                                radioValue = value as String;
                                              });
                                            })),
                                    Text("No",
                                        style: GoogleFonts.lexend(
                                            textStyle: TextStyle(
                                                color: Color(0xff336699),
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400)))
                                  ]),
                                  Row(children: [
                                    Transform.scale(
                                        scale: 1.5,
                                        child: Radio(
                                            value: 3,
                                            groupValue: radioValue,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Color(0xff336699)),
                                            onChanged: (value) {
                                              setState(() {
                                                radioValue = value as String;
                                              });
                                            })),
                                    Text(S.of(context).notNeeded,
                                        style: GoogleFonts.lexend(
                                            textStyle: TextStyle(
                                                color: Color(0xff336699),
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400))),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6)
                                  ])
                                ]),
                          ]),
                          SizedBox(height: 20.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ModalCupertinoPicker(
                                label: S.of(context).remainingProductionTime,
                                onSetHour: (hours) {
                                  setState(() {
                                    remainingHours = hours.hour;
                                    remainingMinute = hours.minute;
                                  });
                                },
                                hours: true),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ModalCupertinoPicker(
                                label: S.of(context).operatingHours,
                                onSetHour: (hours) {
                                  setState(() {
                                    operatingHours = hours.hour;
                                    operatingMinute = hours.minute;
                                  });
                                },
                                hours: true),
                          ),
                          SizedBox(height: 20.0),
                          // save or cancel
                          Row(children: [
                            Expanded(
                                child: Button(
                                    type: "outline",
                                    text: S.of(context).cancel,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    })),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: Button(
                                    text: S.of(context).save, onPressed: () {}))
                          ])
                        ]))))));
  }
}
