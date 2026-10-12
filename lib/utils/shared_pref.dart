import 'package:shared_preferences/shared_preferences.dart';


class SharedPref {

  static const token = "token";
  static const name = "name";

  Future<String> getString(String _key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? '';
  }

  setString(String _key,String _value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, _value);
  }

  Future<bool> getBool(String _key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  setBool(String _key,bool _value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, _value);
  }

  void clear() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}

/***                     created by aHoushmand at 20 July 2020
    ////set///

SharedPref()
    .setString(SharedPref.phone, controllerPhoneNumber.text);

  /// get ///
    SharedPref()
    .getString(SharedPref.nationalCode)
    .then((value) => print(value));

***/
