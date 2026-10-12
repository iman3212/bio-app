
import 'package:flutter/material.dart';
import '../utils/shared_pref.dart';

import '../res/styles.dart';

class ModalLogout extends StatefulWidget {


  const ModalLogout({Key key}) : super(key: key);

  @override
  _ModalLogoutState createState() => _ModalLogoutState();

}

class _ModalLogoutState extends State<ModalLogout> {



  @override
  Widget build(BuildContext context) {

    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Container(
            margin: EdgeInsets.only(bottom: 4,top: 8),
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16)
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(right: 16,top: 16,left: 16),
              child: Text(
                'LogOut of user account?',
                style: Styles.h1StyleBlack,
              ),
            ),
          ),

          Divider(height: 24.0,color: Colors.transparent,),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  SharedPref().clear();


                 // Navigator.of(context).pushAndRemoveUntil(
                 //     MaterialPageRoute(builder: (context) => Initial()),
                 //         (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        fontFamily: 'IranSans',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontFamily: 'IranSans',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            ],
          ),

          Divider(height: 24.0,color: Colors.transparent,),

        ],
      ),
    ));
  }

}
