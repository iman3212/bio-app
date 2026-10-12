
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../network/repository.dart';
import '../res/strings.dart';
import '../res/styles.dart';
import '../utils/dialog.dart';
import '../utils/shared_pref.dart';

class Signin extends StatefulWidget {

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPass = TextEditingController();

  bool _login = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerEmail.text = 'amir55@gmail.com';
    controllerPass.text = 'amir55';
    //
    // SharedPref().setString(SharedPref.token, 'for develop');

    Timer(Duration(seconds: 4),(){
      SharedPref().getString(SharedPref.token).then((value) {

        print('token: $value');
        if(value == ''){
          setState(() {
            _login = true;
          });
        }else{
          Navigator.pushReplacementNamed(context, '/home');
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.6),

        body: _login ? Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 1.6,
            decoration: BoxDecoration(
              color: Color.fromRGBO(83, 80, 120, 1),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              children: [

                SizedBox(height: 16,),

                Image.asset('assets/images/logo.png',width: 150,),

                SizedBox(height: 8,),

                Center(child: Text('Login Account',style: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w600))),

                SizedBox(height: 16,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    textInputAction: TextInputAction.next,
                    onChanged: (value){
                      setState(() {});
                    },
                    // autofocus: true,
                    controller: controllerEmail,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
//                suffixIcon: const Icon(Icons.phone),
                      counterText: "",
                      contentPadding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      border: buildUnderlineInputBorder(),
                      focusedBorder: buildUnderlineInputBorder(),
                      enabledBorder: buildUnderlineInputBorder(),
                      hintText: Strings.email,
                      hintStyle: Theme.of(context).textTheme.subtitle1.apply(color: Colors.white54),
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    textInputAction: TextInputAction.none,
                    // onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onChanged: (value){
                      setState(() {});
                    },
                    controller: controllerPass,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
//                suffixIcon: const Icon(Icons.phone),
                      counterText: "",
                      contentPadding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      border: buildUnderlineInputBorder(),
                      focusedBorder: buildUnderlineInputBorder(),
                      enabledBorder: buildUnderlineInputBorder(),
                      hintText: Strings.pass,
                      hintStyle: Theme.of(context).textTheme.subtitle1.apply(color: Colors.white54),
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 50,
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 17),
                  child: Text(Strings.terms_privacy_signin,style: Theme.of(context).textTheme.caption.apply(color: Colors.white),textAlign: TextAlign.center,),
                ),

                SizedBox(height: 16,),


                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                  child: CupertinoButton(
                    color: Color.fromRGBO(234, 170, 68, 1),
                    borderRadius: BorderRadius.circular(30.0),
                    child: Text('LOG IN',),
                    onPressed: () =>_signInTap(),
                  ),
                ),



              ],
            ),
          ),
        ) : Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/logo.png',width: MediaQuery.of(context).size.width / 2,),
              SizedBox(height: 1,),
              SpinKitThreeBounce(
                color: Colors.white,
                size: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _backTap() {
    Navigator.pop(context);
  }

  _checkValidation(){

    if(controllerEmail.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Please enter email',Colors.blue));
      return false;
    }

    if(controllerPass.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Please enter password',Colors.blue));
      return false;
    }

    return true;

  }

  OverlayEntry overlayEntry;
  _showProgress(){
    overlayEntry = OverlayEntry(builder: (c) {
      return FunkyOverlay();
    });
    Overlay.of(context).insert(overlayEntry);
  }

  _removeProgress(){
    overlayEntry.remove();
  }

  _signInTap() {

    if(!_checkValidation()){
      return;
    }

    _showProgress();
    Repository().login(controllerEmail.text, controllerPass.text).then((value) {

      _removeProgress();

      try{

        final token = value['data']['access_token'];
        SharedPref().setString(SharedPref.token, token);
        SharedPref().setString(SharedPref.name, controllerEmail.text);
        Navigator.pushReplacementNamed(context, '/home');

      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('$e',Colors.red));
      }

    }).catchError((value){
      _removeProgress();
      print('$value');
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Wrong email or password',Colors.red));
    });
  }

  UnderlineInputBorder buildUnderlineInputBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    );
  }

  SnackBar _showSnackBar(String data, var bgColor) {
    return SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        data,
        style: Styles.h2StyleWhite,
        textAlign: TextAlign.left,
      ),
      backgroundColor: bgColor,
    );
  }

}
