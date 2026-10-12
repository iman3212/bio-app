import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../network/server.dart';
import '../res/styles.dart';
import '../widgets/btn.dart';

class TxtForm extends StatelessWidget {
  final action;
  final String onSave;
  final Map map;
  final onCheng;
  final TextStyle txtStyle;
  final bool obsecureTxt;
  final String lableTxt;
  // final Color bgColor;
  final Color txtColor;
  final icon;
  final suffixIcon;
  final Color siffixColor;
  final Validat;
  final bool customBr;
  final BorderSide crBorder;
  const TxtForm(
      {Key key,
        this.action,
         this.map,
         this.onSave,
        this.onCheng,
         this.txtStyle,
         this.obsecureTxt,
         this.lableTxt,
        // required this.bgColor,
         this.txtColor,
        this.icon,
         this.siffixColor,
         this.suffixIcon,
        this.Validat,
        this.customBr = true,
        this.crBorder = const BorderSide()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new TextFormField(
        autofocus: false,
        textInputAction: action,
        onSaved: (val) {
          map['$onSave'] = val;
        },
        onChanged: onCheng,
        validator: Validat,
        style: txtStyle,
        obscureText: obsecureTxt,
        decoration: new InputDecoration(
            labelText: lableTxt,
            fillColor: Color(0xFF525078),
            labelStyle: new TextStyle(color: txtColor),
            filled: true,
            enabledBorder: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(17.5),
              borderSide:
              customBr ? (BorderSide(color: Color(0xFF979797))) : crBorder,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17.5),
                borderSide:
                customBr ? (BorderSide(color: Color(0xFFE9AA43))) : crBorder),
            prefixIcon: Icon(
              icon,
              size: 16,
              color: Color(0xFFE9AA43),
            ),
            suffixIcon: Icon(
              suffixIcon,
              size: 16,
              color: siffixColor,
            )),
      ),
    );
  }
}


class UploadScreen extends StatefulWidget {
  const UploadScreen({Key key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}
class keys {
  static final key1 = GlobalKey<FormState>();
  static final key2 = GlobalKey<FormState>();
}
class _UploadScreenState extends State<UploadScreen> {

  String filePath = '';
  Map data = new Map();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    var wi = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color.fromRGBO(49, 55, 96, 1),
                const Color.fromRGBO(83, 66, 105, 1),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          Column(
            children: [

              SizedBox(height: 42),

              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: (){
                    Navigator.pop(context);
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 6,left: 8),
                    child: Text('Upload STL',style: Styles.h0StyleWhite,),
                  ),
                ],
              ),
            ],
          ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Form(
                    key: keys.key1,
                    child: TxtForm(
                        map: data,
                        onSave: 'title',
                        txtStyle: TextStyle(color: Colors.white),
                        obsecureTxt: false,
                        lableTxt: 'title',
                        txtColor: Colors.white,
                        siffixColor: Colors.white70,
                        suffixIcon: null),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result == null) return;
                      final file = result.files.first;
                      filePath = file.path;
                      print(filePath);
                      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('STl file selected.',Colors.green));
                    },
                    child: Btn(
                      cusColor: true,
                      customColor: Color(0xFF525078),
                      customTxtStyle: true,
                      customTextStyle:
                      TextStyle(color: Colors.white70, fontSize: 17),
                      title: 'choose file',
                      widthContainer: wi,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [


                      GestureDetector(
                        onTap: () async{
                          keys.key1.currentState.save();
                          sendData(filePath);
                        },
                        child: Container(width: double.infinity,padding: EdgeInsets.symmetric(horizontal: 12,vertical: 16),decoration: BoxDecoration(            color: Color.fromRGBO(234, 170, 68, 1),
                          borderRadius: BorderRadius.circular(8), ),child:
                        Center(child:
                          isLoading ? SizedBox(width: 20,height: 20,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)) :Text('Upload',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 18),))),
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      GestureDetector(

                        onTap: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: Colors.white70,fontSize: 17)),
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       child:
                      //       Btn(
                      //
                      //         hasBorder: false,
                      //         title: 'save',
                      //         widthContainer: wi * .5,
                      //       );
                      //     }),

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

  _checkValidation(){

    if(data['title'].isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Please enter title',Colors.blue));
      return false;
    }

    if(filePath == ''){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Please choose file',Colors.blue));
      return false;
    }

    return true;

  }

  void sendData(filename) async {

    if(isLoading){
      return;
    }

    if(!_checkValidation()){
      return;
    }


    setState(() {
      isLoading = true;
    });
    var reponse = SendData().uploadData('uplodeFile', filename,true,'${data['title']}');
    reponse.then((value) {

      print(value.statusCode);
      print(jsonDecode(utf8.decode(value.bodyBytes)));
      var res = jsonDecode(utf8.decode(value.bodyBytes));
      // var jsonres=jsonDecode(ut);
      setState(() {
        isLoading=false;
      });

      if (value.statusCode == 200) {
        Navigator.pop(context,true);
        ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('The operation was successful',Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Error! try again.',Colors.red));
      }

    });
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
