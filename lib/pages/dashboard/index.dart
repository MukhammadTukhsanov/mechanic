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

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List devicesInfo = [];
  List devicesInformation = [];
  ScrollController _scrollBodyController = ScrollController();
  ScrollController _scrollHeaderController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollBodyController.addListener(_onScrollListener);
    getData();
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

  getData() async {
    for (var machineName in globalDevices) {
      try {
        var response = await http.get(
          Uri.parse('http://$ipAdress/api/all_machines/${machineName}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        var data = jsonDecode(response.body);
        print("data: $data");
        Map<String, dynamic> info = {
          'machineName': machineName,
          'data': <dynamic>[],
        };
        for (var i = 0, width = 126; i < data.length; i++) {
          if (data[i]['toolMounted'] == false &&
              data[i]['machineStopped'] == false) {
            if (i + 1 < data.length &&
                data[i + 1]['toolMounted'] == false &&
                data[i + 1]['machineStopped'] == false) {
              width += 126;
            } else {
              info['data'].add({
                'width': data[i]['remainingProductionTime'] / 60 * 15.75,
                'height': 30,
                'color': Color(0xff5cb85c),
                'barcodeProductionNo': data[i]['barcodeProductionNo'],
                'shift': data[i]['shift'],
                'createdAt': data[i]['createdAt']
              });
              // devicesInformation.add({
              //   'width': width,
              //   'height': 30,
              //   'color': Color(0xff5cb85c),
              // });
            }
          } else if (data[i]['toolMounted'] == false &&
              data[i]['machineStopped'] == true) {
            if (i + 1 < data.length &&
                data[i + 1]['toolMounted'] == false &&
                data[i + 1]['machineStopped'] == true) {
              width += 126;
            } else {
              info['data'].add({
                'width': width,
                'height': 30,
                'color': Color(0xffcc0000),
                'barcodeProductionNo': data[i]['barcodeProductionNo'],
                'shift': data[i]['shift'],
                'createdAt': data[i]['createdAt']
              });
            }
          } else if (data[i]['toolMounted'] == true &&
              data[i]['machineStopped'] == false) {
            if (i + 1 < data.length &&
                data[i + 1]['toolMounted'] == true &&
                data[i + 1]['machineStopped'] == false) {
              width += 126;
            } else {
              info['data'].add({
                'width': width,
                'height': 30,
                'color': Color(0xffcc0000),
                'barcodeProductionNo': data[i]['barcodeProductionNo'],
                'shift': data[i]['shift'],
                'createdAt': data[i]['createdAt']
              });
            }
          }
        }
        setState(() {
          devicesInformation = [...devicesInformation, info];
        });
      } catch (e) {
        print(e);
      }
    }
    ;
  }

  final today = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    print("devicesInformation: $devicesInformation");
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
                  icon: Icon(Icons.menu, color: Color(0xff336699), size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
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
                        width: 450,
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
                              ...globalDevices.map((device) {
                                return Container(
                                  width: 450,
                                  child: status(context, device),
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
                                        children: [
                                          Column(
                                            children: [
                                              ...devicesInformation.map((e) =>
                                                  statusLineSquares(
                                                      context, e)),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
                                              // statusLineSquares(context),
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
    return Stack(
      alignment: FractionalOffset.centerLeft,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 30; i > 0; i--)
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
        ...e['data'].map((i) => statusLine(
              context,
              "${i['barcodeProductionNo']}/${i['shift']}/${DateTime.parse(i['createdAt']).toIso8601String().split('T').first}",
              i['color'] == Color(0xff5cb85c)
                  ? "success"
                  : i['color'] == Color(0xffcc0000)
                      ? "danger"
                      : "transparent",
              i['width'].toDouble(),
            ))
      ],
    );
  }

  OverlayEntry? _popupOverlayEntry;
  Timer? _hideTimer;

  void _showPopup(BuildContext context, Offset offset) {
    _popupOverlayEntry = _createPopupOverlayEntry(context, offset);
    Overlay.of(context).insert(_popupOverlayEntry!);

    _hideTimer?.cancel(); // Cancel any existing timer
    _hideTimer = Timer(Duration(seconds: 2), () {
      _removePopup();
    });
  }

  OverlayEntry _createPopupOverlayEntry(BuildContext context, Offset offset) {
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
                      Text("123456789",
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
                      Text("Part Name",
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
                      Text("2021-09-01",
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

  Widget statusLine(context, text, String color, double width) {
    return GestureDetector(
      onTapUp: (details) {
        _removePopup(); // Remove any existing popup
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset localOffset =
            renderBox.globalToLocal(details.globalPosition);
        _showPopup(context, localOffset);
      },
      child: Container(
        width: width,
        height: 19,
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
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  Widget status(context, device) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            // bottom: BorderSide(
            //   color: Color(0xff848484),
            //   width: .5,
            // ),
            // right: BorderSide(
            //   color: Color(0xff848484),
            //   width: .5,
            // ),
            ),
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
          Expanded(
              child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffe6cc00),
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
          )),
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
                      child: Text("12345699",
                          style: GoogleFonts.lexend(
                              fontSize: 18,
                              color: Color(0xff336699),
                              fontWeight: FontWeight.w300))))),
        ],
      ),
    );
  }
}
