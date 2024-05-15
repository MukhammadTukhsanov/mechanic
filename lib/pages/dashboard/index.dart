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
                'width': width,
                'height': 30,
                'color': Color(0xff5cb85c),
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
                height: 102,
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
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollBodyController,
                                dragStartBehavior: DragStartBehavior.start,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        ...devicesInformation.map((e) =>
                                            statusLineSquares(context, e)),
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
                                )),
                          )
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
                height: 50.5,
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
              "text",
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

  Widget statusLine(context, text, String color, double width) {
    return Container(
      width: width,
      height: 30,
      color: color == 'success'
          ? Color(0xff5CB85C)
          : color == 'danger'
              ? Color(0xffcc0000)
              : Colors.transparent,
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.lexend(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  Widget status(context, device) {
    return Container(
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
                  height: 50,
                  child: Center(
                      child: Text(device,
                          style: GoogleFonts.lexend(
                              fontSize: 19,
                              color: Color(0xff336699),
                              fontWeight: FontWeight.w300))))),
          Expanded(
              child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffe6cc00),
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
          )),
          Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text("12345699",
                          style: GoogleFonts.lexend(
                              fontSize: 19,
                              color: Color(0xff336699),
                              fontWeight: FontWeight.w300))))),
        ],
      ),
    );
  }
}
