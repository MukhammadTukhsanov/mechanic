import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State {
  List<bool> expanded = [false, false];
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
                    Text("user",
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
                        Navigator.pop(context);
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
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Color(0xff848484), width: 0.5),
                ),
                child: ExpansionTile(
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                  color: Color(0xff336699), width: 2.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 8.0),
                            child: Text('F45 - 1',
                                style: GoogleFonts.lexend(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff336699),
                                )),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          'Date/Time',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('07/07/2021 10:00 AM',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                        trailing: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Color(0xff336699), width: 1.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.edit, color: Color(0xff336699)),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Shift',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('N3',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Machine ID',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('-',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Production Number',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('123456789',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Partname',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('name',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Part Number',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('123456789',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Cavity',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('1',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Cycle Time',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('2 H',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Status',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('Status',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Number of Pieces Acumulated',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('2',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Note',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text(
                            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Toll Cleaning 24H',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('Ok',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Production Remaining Time',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('2 H',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Operating Hours',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('-',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 20.0),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Color(0xff848484), width: 0.5),
                ),
                child: ExpansionTile(
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                  color: Color(0xff336699), width: 2.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 8.0),
                            child: Text('F45 - 1',
                                style: GoogleFonts.lexend(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff336699),
                                )),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          'Date/Time',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('07/07/2021 10:00 AM',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                        trailing: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Color(0xff336699), width: 1.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.edit, color: Color(0xff336699)),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Shift',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('N3',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Machine ID',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('-',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Production Number',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('123456789',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Partname',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('name',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Part Number',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('123456789',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Cavity',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('1',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Cycle Time',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('2 H',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Status',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('Status',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Number of Pieces Acumulated',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('2',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Note',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text(
                            'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Toll Cleaning 24H',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('Ok',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Production Remaining Time',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('2 H',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Operating Hours',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff336699),
                          ),
                        ),
                        subtitle: Text('-',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              color: Color(0xff336699),
                            )),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 20.0),
          ]),
        )));
  }
}
