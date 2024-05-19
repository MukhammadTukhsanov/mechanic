import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schichtbuch_shift/components/button.dart';
import 'package:schichtbuch_shift/components/cupertino-picker.dart';
import 'package:schichtbuch_shift/components/input.dart';
import 'package:schichtbuch_shift/components/switch.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';
import 'package:schichtbuch_shift/pages/comment/index.dart';
import 'package:schichtbuch_shift/pages/home/machines-list.dart';
import 'package:schichtbuch_shift/pages/mode/index.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _toolMounted = false;
  bool _machineStopped = false;
  bool _partStatusOK = true;
  bool err = false;
  bool added = false;
  bool isStatus = false;
  bool stopTimer = false;
  bool operatingHoursImportant = false;
  bool loadSaving = false;
  bool operatingHoursErr = false;

  String radioValue = 'yes';
  String errText = '';
  String shift = 'S1';

  int days = 0;
  int instRemainingProductionHours = 0;
  int instRemainingProductionMinute = 0;

  String instOperatingHours = "-";
  String instOperatingMinute = "-";

  final _formKey = GlobalKey<FormState>();

  TextEditingController machineQRCodeController = TextEditingController();
  final productionNumberController = TextEditingController();
  final partNumberController = TextEditingController();
  final partNameController = TextEditingController();
  final cavityController = TextEditingController();
  final cycleTimeController = TextEditingController();
  final pieceNumberController = TextEditingController();
  final noteController = TextEditingController();
  final timeController = TextEditingController();

  final FocusNode _machineQRFocus = FocusNode();
  final FocusNode _productionNoFocus = FocusNode();

  late DateTime lastWeekdayOfMonth;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    _timer();
    getTimePeriod();
    lastDay();
    _machineQRFocus.addListener(_onFocusChange);
    _productionNoFocus.addListener(setProductionNo);
    _checkConnectivity();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        if (results.isNotEmpty) {
          _connectivityResult = results.last;
        } else {
          _connectivityResult = ConnectivityResult.none;
        }
      });
    });
  }

  @override
  void dispose() {
    machineQRCodeController.dispose();
    partNumberController.dispose();
    partNameController.dispose();
    cavityController.dispose();
    cycleTimeController.dispose();
    pieceNumberController.dispose();
    noteController.dispose();
    _machineQRFocus.dispose();
    _productionNoFocus.dispose();
    super.dispose();
  }

  DateTime getLastDayOfMonth(int year, int month) {
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    // Check if the last day is Saturday or Sunday
    if (lastDayOfMonth.weekday == DateTime.saturday ||
        lastDayOfMonth.weekday == DateTime.sunday) {
      // If it's Saturday or Sunday, find the last Friday
      while (lastDayOfMonth.weekday != DateTime.friday) {
        lastDayOfMonth = lastDayOfMonth.subtract(Duration(days: 1));
      }
    }

    return lastDayOfMonth;
  }

  void lastDay() {
    // Example usage:
    int today = DateTime.now().day;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    DateTime lastDay = getLastDayOfMonth(year, month);
    setState(() {
      operatingHoursImportant = lastDay.day == today;
    });

    print('Last day of the month: ${lastDay.day == today}');
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult[
          0]; // Extract the first ConnectivityResult from the list
    });
  }

  void _onFocusChange() {
    if (_machineQRFocus.hasFocus) {
      machineQRCodeController.text = "";
    }
  }

  void _timer() {
    var response = http.get(
      Uri.parse('http://${ipAdress}/api/machines/${key}/start'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    response.then((value) {
      var data = jsonDecode(value.body);
    }).catchError((error) {
      print(error);
    });
  }

  getTimePeriod() {
    DateTime now = DateTime.now();

    int currentTime = now.hour * 60 + now.minute;

    if (currentTime >= 6 * 60 && currentTime <= 14 * 60 + 30) {
      setState(() {
        shift = "F1";
      });
    } else if (currentTime >= 14 * 60 && currentTime <= 22 * 60 + 30) {
      setState(() {
        shift = "S2";
      });
    } else {
      setState(() {
        shift = "N3";
      });
    }
  }

  final hour = DateTime.now().hour < 10
      ? '0${DateTime.now().hour}'
      : DateTime.now().hour.toString();
  final minute = DateTime.now().minute < 10
      ? '0${DateTime.now().minute}'
      : DateTime.now().minute.toString();

  addEntry() async {
    if (machineQRCodeController.text == '' && _machineStopped == true) {
      setState(() {
        errText = S.of(context).fillAllFields;
        err = true;
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
      return;
    } else if (machineQRCodeController.text == '' &&
        productionNumberController.text == '' &&
        _machineStopped == false &&
        productionNumberController.text == '' &&
        cavityController.text == '' &&
        cycleTimeController.text == '' &&
        pieceNumberController.text == '') {
      setState(() {
        errText = S.of(context).fillAllFields;
        err = true;
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
      return;
    }
    setState(() {
      loadSaving = true;
    });
    var response = await http.post(
      Uri.parse('http://${ipAdress}/api/machines'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "createdAt": "${DateTime.now()}", // String
        "token": "$key", // String
        "shift": "$shift", // String
        "machineQrCode": "${machineQRCodeController.text}", // String
        "toolMounted": _toolMounted, // true or false
        "machineStopped": _machineStopped, // true or false
        "barcodeProductionNo":
            double.parse(productionNumberController.text), // String
        "cavity": double.parse(cavityController.text), // double
        "cycleTime": "${cycleTimeController.text}", // String
        "partStatus": _partStatusOK, // true or false
        "pieceNumber": double.parse(pieceNumberController.text), // double
        "note": "${noteController.text}", // String
        "toolCleaning": radioValue, // String
        "remainingProductionDays": days, // int
        "remainingProductionTime": instRemainingProductionHours * 60 +
            instRemainingProductionMinute, // int
        "operatingHours":
            "$instOperatingHours".replaceAll("-", "0").padLeft(2, "0") +
                ":" +
                "$instOperatingMinute"
                    .replaceAll("-", "0")
                    .padLeft(2, "0"), // double
      }),
    );
    print("response.body: ${response.body}");
    print("response.body: ${response.statusCode}");
    if (response.statusCode == 400) {
      showSnackBarFun(context, S.of(context).errorSaving, "error");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
    }
    if (response.statusCode == 422) {
      showSnackBarFun(context, S.of(context).errorSaving, "error");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      showSnackBarFun(context, S.of(context).entryAdded, "success");
      if (data['total'] == globalDevices.length) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CommentPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
    setState(() {
      loadSaving = false;
    });
  }

  onChangedQrCode(String value) {
    print("value: $value");
    globalDevices.forEach((element) {
      if (element == value) {
        _machineQRFocus.unfocus();
        print("element: $element");
      }
    });
  }

  onChangeToolMounted() {
    if (_toolMounted) {
      onMachineStopped();
      setState(() {
        _machineStopped = false;
      });
    } else {
      onMachineStopped();
      setState(() {
        _machineStopped = true;
      });
    }
    setState(() {
      _toolMounted = !_toolMounted;
    });
  }

  showSnackBarFun(context, String text, String status) {
    SnackBar snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
      backgroundColor: status == "success" ? Colors.green : Colors.red,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  onMachineStopped() {
    if (!_machineStopped) {
      setState(() {
        cavityController.text = '0';
        pieceNumberController.text = '0';
        productionNumberController.text = '0';
      });
    } else {
      setState(() {
        cavityController.text = '';
        pieceNumberController.text = '';

        productionNumberController.text = '';
        partNumberController.text = '';
        partNameController.text = '';
        cycleTimeController.text = '';
        noteController.text = '';
      });
    }
    ;
    setState(() {
      _machineStopped = !_machineStopped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChooseMode()));
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(S.of(context).addEntry,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        border:
                            Border.all(color: Color(0xff336699), width: 1.0)),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: Color(0xff336699), size: 30.0),
                        SizedBox(width: 10.0),
                        Text(user,
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(width: 40.0),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              stopTimer = true;
                            });
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChooseMode();
                            }));
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
            body: _connectivityResult == ConnectivityResult.none
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 100, color: Colors.red[200]),
                      SizedBox(height: 20),
                      Text(S.of(context).noInternetConnection,
                          style: GoogleFonts.lexend(
                              textStyle: const TextStyle(
                                  color: Color(0xff848484),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)))
                    ],
                  ))
                : Row(children: [
                    Container(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                            reverse: false,
                            child: Container(
                                color: Colors.white,
                                width: 145,
                                child: Column(children: [
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  MachineStatusList(
                                    changeStatus: isStatus,
                                  ),
                                ])))),
                    Expanded(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: SingleChildScrollView(
                                child: Container(
                                    color: Colors.white,
                                    width: 120,
                                    child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(children: [
                                            Stack(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        DateTime.now()
                                                                .day
                                                                .toString() +
                                                            ' ' +
                                                            monthNames[
                                                                DateTime.now()
                                                                        .month -
                                                                    1] +
                                                            ' ' +
                                                            DateTime.now()
                                                                .year
                                                                .toString() +
                                                            ' | ' +
                                                            hour +
                                                            ':' +
                                                            minute +
                                                            ' | ' +
                                                            "${S.of(context).shift}  ${shift}",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lexend(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xff848484),
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)))),
                                                err
                                                    ? Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons.error,
                                                                color: Colors
                                                                    .white),
                                                            SizedBox(
                                                                width: 20.0),
                                                            Text(errText,
                                                                style: GoogleFonts.lexend(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w400))),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(height: 0.0),
                                              ],
                                            ),
                                            SizedBox(height: 16.0),
                                            Input(
                                                onChanged: onChangedQrCode,
                                                focusNode: _machineQRFocus,
                                                controller:
                                                    machineQRCodeController,
                                                prefixIcon: Icons.qr_code,
                                                labelText: S
                                                    .of(context)
                                                    .scanMachineQRCode),
                                            SizedBox(height: 16.0),
                                            Stack(children: [
                                              SwitchWithText(
                                                  value: _toolMounted,
                                                  label:
                                                      S.of(context).toolMounted,
                                                  onChange:
                                                      onChangeToolMounted),
                                              Positioned(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      30,
                                                  child: SwitchWithText(
                                                    value: _machineStopped,
                                                    label: S
                                                        .of(context)
                                                        .machineStopped,
                                                    onChange: !_toolMounted
                                                        ? onMachineStopped
                                                        : null,
                                                  ))
                                            ]),

                                            SizedBox(height: 16.0),
                                            ///////////////////////////////////////////////////////////////////////
                                            _machineStopped
                                                ? SizedBox(height: 0.0)
                                                : IsStoped(),
                                            Row(children: [
                                              Expanded(
                                                  child: Button(
                                                      type: "outline",
                                                      text:
                                                          S.of(context).cancel,
                                                      onPressed: () {
                                                        setState(() {
                                                          stopTimer = true;
                                                        });
                                                        Navigator.pop(context);
                                                      })),
                                              SizedBox(width: 20.0),
                                              Expanded(
                                                  child: Button(
                                                loading: loadSaving,
                                                text: S.of(context).save,
                                                onPressed: () {
                                                  validateOperating();
                                                  if (_formKey.currentState!
                                                          .validate() &&
                                                      !operatingHoursErr &&
                                                      !loadSaving) {
                                                    addEntry();
                                                  }
                                                },
                                              ))
                                            ])
                                          ]),
                                        ))))))
                  ])));
  }

  setProductionNo() {
    if (productionNumberController.text.length < 2) {
      return;
    }
    // http get request
    var response = http.get(
      Uri.parse(
          'http://${ipAdress}/api/productionnumber/${productionNumberController.text}'), // 80735001
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    response.then((value) {
      var data = jsonDecode(value.body);
      if (data["Partnumber"] != "0" && data['Partname'] != "0") {
        partNumberController.text = "${data['Partnumber']}";
        partNameController.text = "${data['Partname']}";
      } else {
        partNumberController.text = "Not Found";
        partNameController.text = "Not Found";
      }
    }).catchError((error) {
      errText = error.toString();

      setState(() {
        err = true;
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          err = false;
        });
      });
      print(error);
    });
  }

  Widget IsStoped() {
    return Column(
      children: [
        Input(
            validator: _machineStopped ? false : true,
            maxLength: 9,
            focusNode: _productionNoFocus,
            keyboardType: TextInputType.number,
            numericOnly: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: productionNumberController,
            prefixIcon: Icons.qr_code,
            labelText: S.of(context).scanBarcodeProductionNo),
        SizedBox(height: 16.0),
        Row(children: [
          Expanded(
              child: Input(
            validator: false,
            controller: partNumberController,
            labelText: S.of(context).partNumber,
            disabled: true,
          )),
          SizedBox(width: 20.0),
          Expanded(
              child: Input(
                  validator: false,
                  controller: partNameController,
                  labelText: S.of(context).partName,
                  disabled: true))
        ]),
        SizedBox(height: 16.0),
        Input(
            labelText: S.of(context).cavity,
            validator: _machineStopped ? false : true,
            numericOnly: true,
            keyboardType: TextInputType.number,
            controller: cavityController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        SizedBox(height: 16.0),
        Input(
            labelText: S.of(context).cycleTime,
            validator: _machineStopped ? false : true,
            numericOnly: true,
            keyboardType: TextInputType.number,
            controller: cycleTimeController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-><,]'))
            ]),
        SizedBox(height: 16.0),
        SwitchWithText(
            value: _partStatusOK,
            label: S.of(context).partStatusOk,
            onChange: () {
              setState(() {
                _partStatusOK = !_partStatusOK;
              });
            }),
        SizedBox(height: 16.0),
        Input(
            labelText: S.of(context).pieceNumber,
            validator: _machineStopped ? false : true,
            numericOnly: true,
            keyboardType: TextInputType.number,
            controller: pieceNumberController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        SizedBox(height: 16.0),
        Input(
            validator: false,
            controller: noteController,
            maxLines: 4,
            labelText: S.of(context).note),
        SizedBox(height: 16.0),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(S.of(context).toolCleaningShiftF1Done,
                textAlign: TextAlign.left,
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600)))),
        SizedBox(width: 20.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: "yes",
                    groupValue: radioValue,
                    fillColor:
                        MaterialStateProperty.all(const Color(0xff336699)),
                    onChanged: (value) {
                      setState(() {
                        radioValue = value as String;
                      });
                    })),
            Text(S.of(context).yes,
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600)))
          ]),
          Row(children: [
            Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: "no",
                    groupValue: radioValue,
                    fillColor:
                        MaterialStateProperty.all(const Color(0xff336699)),
                    onChanged: (value) {
                      setState(() {
                        radioValue = value as String;
                      });
                    })),
            Text(S.of(context).no,
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600)))
          ]),
          Row(children: [
            Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: "notNeeded",
                    groupValue: radioValue,
                    fillColor: MaterialStateProperty.all(Color(0xff336699)),
                    onChanged: (value) {
                      setState(() {
                        radioValue = value as String;
                      });
                    })),
            Text(S.of(context).notNeeded,
                style: GoogleFonts.lexend(
                    textStyle: TextStyle(
                        color: Color(0xff336699),
                        fontSize: 22,
                        fontWeight: FontWeight.w600))),
            SizedBox(width: MediaQuery.of(context).size.width / 6),
          ])
        ]),
        SizedBox(height: 16.0),
        Row(children: [
          Expanded(
              child: ModalCupertinoPicker(
            label: S.of(context).remainingProductionDays,
            labelFontSize:
                Localizations.localeOf(context).languageCode == 'de' ? 15 : 22,
            selectedDate: days,
            onSelect: (index) {
              setState(() {
                days = index;
              });
            },
          )),
          SizedBox(width: 20.0),
          Expanded(
            child: ModalCupertinoPicker(
              label: S.of(context).remainingProductionTime,
              labelFontSize:
                  Localizations.localeOf(context).languageCode == 'de'
                      ? 15
                      : 22,
              hours: true,
              selectedDate: instRemainingProductionHours,
              onSetHour: (value) {
                print(value);
                setState(() {
                  print(value['hours']);
                  instRemainingProductionHours = value['hours'];
                  instRemainingProductionMinute = value['minutes'];
                });
              },
            ),
          )
        ]),
        SizedBox(height: 16.0),
        operatingHoursImportant
            ? ModalCupertinoPicker(
                error: _machineStopped ? false : operatingHoursErr,
                label: S.of(context).operatingHours,
                hours: true,
                selectedDate: 0,
                onSetHour: (value) {
                  setState(() {
                    instOperatingHours = value['hours'].toString();
                    instOperatingMinute = value['minutes'].toString();
                  });
                },
              )
            : SizedBox(height: 0.0),
        operatingHoursImportant
            ? SizedBox(height: 16.0)
            : SizedBox(height: 0.0),
      ],
    );
  }

  validateOperating() {
    if ((instOperatingHours == "-" || instOperatingMinute == "-") &&
        !_machineStopped &&
        operatingHoursImportant) {
      setState(() {
        operatingHoursErr = true;
      });
    } else {
      setState(() {
        operatingHoursErr = false;
      });
    }
  }
}
