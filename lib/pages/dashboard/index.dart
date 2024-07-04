import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';
import 'package:schichtbuch_shift/pages/dashboard/left-side.dart';
import 'package:schichtbuch_shift/pages/dashboard/right-side.dart';
import 'package:schichtbuch_shift/pages/mode/index.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List devicesInfo = [];
  List devicesInformation = [];
  List machines = [];
  ScrollController _scrollBodyController = ScrollController();
  ScrollController _scrollHeaderController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime createdAt = DateTime.now();
  DateTime startDatse = DateTime(2024, 5, 20); // example start date
  DateTime endDate = DateTime(2024, 5, 21); // example end date

  @override
  void initState() {
    super.initState();
    setState(() {
      machines = globalDevices;
    });
    _scrollBodyController.addListener(_onScrollListener);
    // getData();
    getMachinesList();
  }

  @override
  void dispose() {
    _scrollBodyController.removeListener(_onScrollListener);
    _scrollBodyController.dispose();
    _hideTimer?.cancel(); // Cancel any existing timer
    super.dispose();
  }

  void _onScrollListener() {
    _scrollHeaderController.jumpTo(_scrollBodyController.offset);
  }

  getMachinesList() async {
    var response = await http.get(Uri.parse('http://$ipAdress/api/machines'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        globalDevices = [];
      });

      data.map(
        (e) {
          setState(() {
            globalDevices = [...globalDevices, e['machineQrCode']];
          });
        },
      ).toList();
      print(data);
    }
    getData();
  }

  getData() async {
    List devices = [];
    for (var machineName in globalDevices) {
      try {
        var response = await http.get(
          Uri.parse('http://$ipAdress/api/machine/status/${machineName}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        var data = jsonDecode(response.body);
        if (data['status'] == "Invalid") {
          var reResponse = await http.get(
            Uri.parse(
                'http://$ipAdress/api/machine/status/${machineName.replaceAll(RegExp(r'\s+'), '')}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          data = jsonDecode(reResponse.body);
        }
        var info = {
          'machineName': machineName,
          'createdAt': data['status'] != "Invalid"
              ? DateTime.parse(data['createdAt'])
              : null,
          'data': data,
        };
        if (data['machineStopped'] == true) {
          devices.add({
            'machineName': machineName,
            'status': "danger",
            'barcodeProductionNo': data['barcodeProductionNo'],
          });
        } else if (data['toolMounted'] == false) {
          devices.add({
            'machineName': machineName,
            'status': "success",
            'barcodeProductionNo': data['barcodeProductionNo'],
          });
        } else {
          devices.add({
            'machineName': machineName,
            'status': "transparent",
            'barcodeProductionNo': data['barcodeProductionNo'],
          });
        }
        setState(() {
          devicesInformation = [...devicesInformation, info];
        });
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      machines = devices;
    });
  }

  parsingStringDateTime(String dateTimeString) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(dateTimeString);
    } catch (e) {
      dateTime =
          DateTime.now(); // fallback to current date-time if parsing fails
    }
    return dateTime.hour * 63 + dateTime.minute * 1.05;
  }

  final today = DateTime.now().day;
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(S.of(context).addEntry,
                style: TextStyle(
                    color: Color(0xff336699),
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Color(0xff336699), size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip);
            }),
            actions: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: Color(0xff336699), width: 1.0)),
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
                        removeToken();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChooseMode();
                        }));
                      },
                      icon: Icon(Icons.logout, color: Colors.red, size: 30.0)))
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
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 100,
                color: Color(0xfffff),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 400,
                        color: Colors.white,
                        child: DashboardLeftSide()),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollHeaderController,
                        scrollDirection: Axis.horizontal,
                        dragStartBehavior: DragStartBehavior.start,
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          color: Colors.white,
                          child: DashboardRightSide(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              ...machines.map((device) {
                                return Container(
                                  width: 400,
                                  child: device is String
                                      ? status(
                                          context, device, 'transparent', '---')
                                      : status(
                                          context,
                                          device['machineName'],
                                          device['status'],
                                          device['barcodeProductionNo']),
                                );
                              }),
                            ],
                          ),
                          Expanded(
                              child: (globalDevices.length ==
                                      [...devicesInformation].length)
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      controller: _scrollBodyController,
                                      dragStartBehavior:
                                          DragStartBehavior.start,
                                      child: Stack(
                                        clipBehavior: Clip.hardEdge,
                                        alignment: FractionalOffset.centerLeft,
                                        children: [
                                          Column(
                                            children: [
                                              ...devicesInformation.map((e) {
                                                return statusLineSquares(
                                                    context, e);
                                              }),
                                            ],
                                          )
                                        ],
                                      ))
                                  : Align(
                                      alignment: Alignment.topCenter,
                                      child: CircularProgressIndicator(),
                                    ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget statusLineSquares(context, e) {
    // print(
    //     "remainingProductionDays ${e['data']['remainingProductionDays'] is int}");
    // print(
    //     "remainingProductionTime ${e['data']['remainingProductionTime'] is int}");
    String partName = e['data']['partname'].toString();
    String partNumber = e['data']['partnumber'].toString();
    DateTime finishingDate = e['data']['remainingProductionDays'] is int
        ? e['createdAt'].add(Duration(
            days: e['data']['remainingProductionDays'],
            minutes: e['data']['remainingProductionTime']))

        // ? addTimeSkippingWeekends(
        //     e['createdAt'],
        //     e['data']['remainingProductionDays'],
        //     e['data']['remainingProductionTime'])
        : DateTime.now();
    return Stack(
      clipBehavior: Clip.hardEdge,
      alignment: FractionalOffset.centerLeft,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 42; i > 0; i--)
              Container(
                width: 63,
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
              ),
          ],
        ),
        Positioned(
          left: e["createdAt"] == null
              ? 0
              : !isToday(e["createdAt"])
                  ? 0
                  : (e["createdAt"].hour * 15.75).toDouble(),
          child: statusLine(
              context,
              "$partNumber/$partName/${finishingDate.toString().substring(0, 16)}",
              e['data']['machineStopped'] == false &&
                      e['data']['toolMounted'] == false
                  ? 'success'
                  : e['data']['machineStopped'] == true
                      ? 'danger'
                      : 'transparent',
              (e['data']['remainingProductionTime'] ?? 0).toDouble(),
              e["createdAt"] == null ? DateTime.now() : e["createdAt"],
              (e['data']['remainingProductionDays'] ?? 0).toDouble(),
              partName.toString(),
              partNumber.toString(),
              "${finishingDate.toString().substring(0, 16)}"),
        ),
      ],
    );
  }

  OverlayEntry? _popupOverlayEntry;
  Timer? _hideTimer;

  void _showPopup(BuildContext context, Offset offset, String partName,
      String partNumber, String finishingDate) {
    _popupOverlayEntry = _createPopupOverlayEntry(
        context, offset, partName, partNumber, finishingDate);
    Overlay.of(context).insert(_popupOverlayEntry!);

    _hideTimer?.cancel(); // Cancel any existing timer
    _hideTimer = Timer(Duration(seconds: 2), () {
      _removePopup();
    });
  }

  OverlayEntry _createPopupOverlayEntry(BuildContext context, Offset offset,
      String partName, String partNumber, String finishingDate) {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(40, 5, 119, 190),
                        spreadRadius: 4,
                        blurRadius: 4)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(S.of(context).partNumber + ": ",
                          style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff336699))),
                      Text(partNumber,
                          style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff336699))),
                    ],
                  ),
                  Row(
                    children: [
                      Text(S.of(context).partName + ": ",
                          style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff336699))),
                      Text(partName,
                          style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff336699))),
                    ],
                  ),
                  Row(
                    children: [
                      Text(S.of(context).date + ": ",
                          style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff336699))),
                      Text(finishingDate,
                          style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff336699))),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _removePopup() {
    _popupOverlayEntry?.remove();
    _popupOverlayEntry = null;
  }

  Widget statusLine(
      context,
      text,
      String color,
      double remainingProductionTime,
      createdAt,
      remainingProductionDays,
      String partName,
      String partNumber,
      String finishingDate) {
    print("remainingProductionDays $remainingProductionDays");
    print("remainingProductionTime $remainingProductionTime");
    double lineWidth =
        (remainingProductionTime / 60 + remainingProductionDays * 24) * 15.75 -
            (DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ).difference(createdAt).inHours +
                    1) *
                15.75 -
            (!isToday(createdAt) ? 0 : (createdAt.hour - 1) * 15.75);
    // !isToday(e["createdAt"]
    //               ? 0
    //               : (e["createdAt"].hour * 15.75).toDouble());
    // newCalculateDaysExcludingWeekends(createdAt, DateTime.now()) *
    //     15.75;
    lineWidth = lineWidth < 0 ? 0 : lineWidth;
    return GestureDetector(
      onTapUp: (details) {
        _removePopup(); // Remove any existing popup
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset localOffset =
            renderBox.globalToLocal(details.globalPosition);
        _showPopup(context, localOffset, partName, partNumber, finishingDate);
      },
      child: Container(
        width: color == 'success' ? lineWidth : null,
        height: 28,
        color: color == 'success'
            ? Color(0xff5CB85C)
            : color == 'danger'
                ? Color(0xffcc0000)
                : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lexend(
                  fontSize: color == 'success' || color == 'danger' ? 18 : 0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget status(context, device, statusColor, productionNo) {
    return Container(
      decoration: BoxDecoration(
        border: Border(),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Color(0xff848484),
                        width: .5,
                      ),
                      bottom: BorderSide(
                        color: Color(0xff848484),
                        width: .5,
                      ),
                    ),
                  ),
                  height: 50,
                  child: Center(
                      child: Text(device,
                          style: GoogleFonts.lexend(
                              fontSize: 18,
                              color: Color(0xff336699),
                              fontWeight: FontWeight.w300))))),
          Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Color(0xff848484),
                  width: .5,
                ),
                bottom: BorderSide(
                  color: Color(0xff848484),
                  width: .5,
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: statusColor == 'success'
                    ? Color(0xff5CB85C)
                    : statusColor == 'danger'
                        ? Color(0xffcc0000)
                        : Colors.transparent,
              ),
            ),
          ),
          Expanded(
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Color(0xff848484),
                        width: .5,
                      ),
                      bottom: BorderSide(
                        color: Color(0xff848484),
                        width: .5,
                      ),
                    ),
                  ),
                  child: Center(
                      child: Text(
                          productionNo == null ? '---' : "$productionNo",
                          style: GoogleFonts.lexend(
                              fontSize: 18,
                              color: Color(0xff336699),
                              fontWeight: FontWeight.w300))))),
        ],
      ),
    );
  }
}
