// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Shift Log`
  String get shiftLog {
    return Intl.message(
      'Shift Log',
      name: 'shiftLog',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login {
    return Intl.message(
      'Log In',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Token ID`
  String get tokenId {
    return Intl.message(
      'Token ID',
      name: 'tokenId',
      desc: '',
      args: [],
    );
  }

  /// `Token ID is not valid`
  String get tokenNotValid {
    return Intl.message(
      'Token ID is not valid',
      name: 'tokenNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out this field`
  String get requiredField {
    return Intl.message(
      'Please fill out this field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Add Entry`
  String get addEntry {
    return Intl.message(
      'Add Entry',
      name: 'addEntry',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get january {
    return Intl.message(
      'January',
      name: 'january',
      desc: '',
      args: [],
    );
  }

  /// `February`
  String get february {
    return Intl.message(
      'February',
      name: 'february',
      desc: '',
      args: [],
    );
  }

  /// `March`
  String get march {
    return Intl.message(
      'March',
      name: 'march',
      desc: '',
      args: [],
    );
  }

  /// `April`
  String get april {
    return Intl.message(
      'April',
      name: 'april',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get may {
    return Intl.message(
      'May',
      name: 'may',
      desc: '',
      args: [],
    );
  }

  /// `June`
  String get june {
    return Intl.message(
      'June',
      name: 'june',
      desc: '',
      args: [],
    );
  }

  /// `July`
  String get july {
    return Intl.message(
      'July',
      name: 'july',
      desc: '',
      args: [],
    );
  }

  /// `August`
  String get august {
    return Intl.message(
      'August',
      name: 'august',
      desc: '',
      args: [],
    );
  }

  /// `September`
  String get september {
    return Intl.message(
      'September',
      name: 'september',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get october {
    return Intl.message(
      'October',
      name: 'october',
      desc: '',
      args: [],
    );
  }

  /// `November`
  String get november {
    return Intl.message(
      'November',
      name: 'november',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get december {
    return Intl.message(
      'December',
      name: 'december',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Shift`
  String get shift {
    return Intl.message(
      'Shift',
      name: 'shift',
      desc: '',
      args: [],
    );
  }

  /// `Scan Machine QR Code`
  String get scanMachineQRCode {
    return Intl.message(
      'Scan Machine QR Code',
      name: 'scanMachineQRCode',
      desc: '',
      args: [],
    );
  }

  /// `Tool Mounted`
  String get toolMounted {
    return Intl.message(
      'Tool Mounted',
      name: 'toolMounted',
      desc: '',
      args: [],
    );
  }

  /// `Machine Stopped`
  String get machineStopped {
    return Intl.message(
      'Machine Stopped',
      name: 'machineStopped',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Scan Barcode Production No.`
  String get scanBarcodeProductionNo {
    return Intl.message(
      'Scan Barcode Production No.',
      name: 'scanBarcodeProductionNo',
      desc: '',
      args: [],
    );
  }

  /// `Part Number`
  String get partNumber {
    return Intl.message(
      'Part Number',
      name: 'partNumber',
      desc: '',
      args: [],
    );
  }

  /// `Part Name`
  String get partName {
    return Intl.message(
      'Part Name',
      name: 'partName',
      desc: '',
      args: [],
    );
  }

  /// `Cavity`
  String get cavity {
    return Intl.message(
      'Cavity',
      name: 'cavity',
      desc: '',
      args: [],
    );
  }

  /// `Cycle Time`
  String get cycleTime {
    return Intl.message(
      'Cycle Time',
      name: 'cycleTime',
      desc: '',
      args: [],
    );
  }

  /// `Part Status OK`
  String get partStatusOk {
    return Intl.message(
      'Part Status OK',
      name: 'partStatusOk',
      desc: '',
      args: [],
    );
  }

  // partStatusBad
  String get partStatusBad {
    return Intl.message(
      'Part Status Bad',
      name: 'partStatusBad',
      desc: '',
      args: [],
    );
  }

  /// `Piece Number`
  String get pieceNumber {
    return Intl.message(
      'Piece Number',
      name: 'pieceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Tool Cleaning Shift F1 Done`
  String get toolCleaningShiftF1Done {
    return Intl.message(
      'Tool Cleaning Shift F1 Done',
      name: 'toolCleaningShiftF1Done',
      desc: '',
      args: [],
    );
  }

  /// `Not needed`
  String get notNeeded {
    return Intl.message(
      'Not needed',
      name: 'notNeeded',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get hours {
    return Intl.message(
      'hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Operating Hours`
  String get operatingHours {
    return Intl.message(
      'Operating Hours',
      name: 'operatingHours',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Machine ID`
  String get machineID {
    return Intl.message(
      'Machine ID',
      name: 'machineID',
      desc: '',
      args: [],
    );
  }

  /// `Modify Existing Entries`
  String get modifyExistingEntries {
    return Intl.message(
      'Modify Existing Entries',
      name: 'modifyExistingEntries',
      desc: '',
      args: [],
    );
  }

  /// `Production Number`
  String get productionNumber {
    return Intl.message(
      'Production Number',
      name: 'productionNumber',
      desc: '',
      args: [],
    );
  }

  /// `Number of Pieces Acumulated`
  String get numberOfPiecesAcumulated {
    return Intl.message(
      'Number of Pieces Acumulated',
      name: 'numberOfPiecesAcumulated',
      desc: '',
      args: [],
    );
  }

  /// `Preparation of Shift OK`
  String get preparationOfShift {
    return Intl.message(
      'Preparation of Shift OK',
      name: 'preparationOfShift',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Production Days`
  String get remainingProductionDays {
    return Intl.message(
      'Remaining Production Days',
      name: 'remainingProductionDays',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Production Time`
  String get remainingProductionTime {
    return Intl.message(
      'Remaining Production Time',
      name: 'remainingProductionTime',
      desc: '',
      args: [],
    );
  }

  /// `Mode Selection`
  String get modeSelection {
    return Intl.message(
      'Mode Selection',
      name: 'modeSelection',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out all fields`
  String get fillAllFields {
    return Intl.message(
      'Please fill out all fields',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Succesfully saved`
  String get succesfullySaved {
    return Intl.message(
      'Succesfully saved',
      name: 'succesfullySaved',
      desc: '',
      args: [],
    );
  }

  /// `Error saving`
  String get errorSaving {
    return Intl.message(
      'Error saving',
      name: 'errorSaving',
      desc: '',
      args: [],
    );
  }

  /// `Entry added`
  String get entryAdded {
    return Intl.message(
      'Entry added',
      name: 'entryAdded',
      desc: '',
      args: [],
    );
  }

  /// `Edit Info`
  String get editInfo {
    return Intl.message(
      'Edit Info',
      name: 'editInfo',
      desc: '',
      args: [],
    );
  }

  /// `Machine QR Code`
  String get machineQRCode {
    return Intl.message(
      'Machine QR Code',
      name: 'machineQRCode',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `New Entry`
  String get newEntry {
    return Intl.message(
      'New Entry',
      name: 'newEntry',
      desc: '',
      args: [],
    );
  }

  /// `Change Entry`
  String get changeEntry {
    return Intl.message(
      'Change Entry',
      name: 'changeEntry',
      desc: '',
      args: [],
    );
  }

  /// `Machine`
  String get machine {
    return Intl.message(
      'Machine',
      name: 'machine',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Productionsnr`
  String get ProductNo {
    return Intl.message(
      'Productionsnr',
      name: 'ProductNo',
      desc: '',
      args: [],
    );
  }

  /// `Enter Time`
  String get enterTime {
    return Intl.message(
      'Enter Time',
      name: 'enterTime',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message(
      'Hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get minute {
    return Intl.message(
      'Minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `KTBU Maschinen Dashboard`
  String get KTBUMaschinenDashboard {
    return Intl.message(
      'KTBU Maschinen Dashboard',
      name: 'KTBUMaschinenDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// 'waitingForMaterial'
  String get waitingForMaterial {
    return Intl.message(
      'Waiting for material',
      name: 'waitingForMaterial',
      desc: '',
      args: [],
    );
  }

  /// 'noMaterial'
  String get noMaterial {
    return Intl.message(
      'No material',
      name: 'noMaterial',
      desc: '',
      args: [],
    );
  }

  /// 'noStaff'
  String get noStaff {
    return Intl.message(
      'No staff',
      name: 'noStaff',
      desc: '',
      args: [],
    );
  }

  /// 'materialNotDry'
  String get materialNotDry {
    return Intl.message(
      'Material not dry',
      name: 'materialNotDry',
      desc: '',
      args: [],
    );
  }

  /// 'startInTheNextShift'
  String get startInTheNextShift {
    return Intl.message(
      'Start in the next shift',
      name: 'startInTheNextShift',
      desc: '',
      args: [],
    );
  }

  /// 'wzDefective'
  String get wzDefective {
    return Intl.message(
      'WZ defective',
      name: 'wzDefective',
      desc: '',
      args: [],
    );
  }

  /// 'machineDefective'
  String get machineDefective {
    return Intl.message(
      'Machine defective',
      name: 'machineDefective',
      desc: '',
      args: [],
    );
  }

  /// 'peripheralDefective'
  String get peripheralDefective {
    return Intl.message(
      'Peripheral defective',
      name: 'peripheralDefective',
      desc: '',
      args: [],
    );
  }

  /// 'noteTextCombinations'
  String get noteTextCombinations {
    return Intl.message(
      'Note text combinations',
      name: 'noteTextCombinations',
      desc: '',
      args: [],
    );
  }
  // skipped getter for the 'entriesAddedForАllМachines' key
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
