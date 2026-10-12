
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class Utils{

}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 0.4));

  return hslLight.toColor();
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

void configStatusBar() {

  if(Platform.isAndroid){
    print('android');
  }

  if(Platform.isFuchsia){
    print('fuchsia');
  }

  if(Platform.isIOS){
    print('ios');
  }

  if(Platform.isLinux){
    print('linux');
  }

  if(Platform.isMacOS){
    print('mac');
  }

  if(Platform.isWindows){
    print('win');
  }
//  if (Platform.isAndroid) {
//    // Android-specific code
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Colors.transparent,
//      statusBarIconBrightness: Brightness.dark,
//      statusBarBrightness:
//      Platform.isAndroid ? Brightness.dark : Brightness.light,
//      systemNavigationBarColor: Colors.white,
//      systemNavigationBarDividerColor: Colors.grey,
//      systemNavigationBarIconBrightness: Brightness.dark,
//    ));
//  }

}

String validationPhone(String phone){
  String _phone;
  if(phone.startsWith('09')){
    _phone = '98${phone.substring(1)}';
  }else if(phone.startsWith('+98')){
    _phone = '${phone.substring(1)}';
  }else if(phone.startsWith('+0098')){
    _phone = '${phone.substring(3)}';
  }
  return _phone;
}

bool checkValidationPhone(String phone){
  bool validation = false;

  if (RegExp("(^(09|9|989|00989|\\+989)[1|9][0-9]\\d{7})").hasMatch(phone))
    validation = true;
  // return 1;//MCI
  if (RegExp("(^(09|9|989|00989|\\+989)(01|02|03|04|05|30|33|35|36|37|38|39)[0-9]\\d{6})").hasMatch(phone))
    validation = true;
  // return 2;//MTN
  if (RegExp("(^(09|9|989|00989|\\+989)[2][0-2][0-9]\\d{6})").hasMatch(phone))
    validation = true;
  // return 3;//Rightel
  if (RegExp( "(^(09|9|989|00989|\\+989)[3][2][0-9]\\d{6})").hasMatch(phone))
    validation = true;
  // return 4;//Taliya
  if (RegExp( "(^(09|9|989|00989|\\+989)[3][1][0-9]\\d{6})").hasMatch(phone))
    validation = true;
  // return 5;//MTCE
  if (RegExp( "(^(09|9|989|00989|\\+989)[3][4][0-9]\\d{6})").hasMatch(phone))
    validation = true;
  // return 6;//Kish-TCI

  return validation;
}
//
// formattedCurrency(int currency) {
//   final oCcy = new intl.NumberFormat("#,##0", "en_US");
//   return oCcy.format(currency);
// }