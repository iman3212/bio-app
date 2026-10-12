import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../utils/shared_pref.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    DatabaseHelper().initializeDatabase();

    DatabaseHelper db = DatabaseHelper();


    Timer(Duration(seconds: 4),() async{

      SharedPref().getString(SharedPref.token).then((value) {

        // print('token: $value');
        if(value == ''){
          Navigator.pushReplacementNamed(context, '/signin');
        }else{
          Navigator.pushReplacementNamed(context, '/home');
        }

      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromRGBO(83, 66, 105, 1),body: Center(child: Image.asset('assets/images/logo.png',fit: BoxFit.cover,width: MediaQuery.of(context).size.width  / 2 ,)));
  }

}
