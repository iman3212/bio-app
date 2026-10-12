import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


class DialogHelper{

  static Future<void> logOutDialog(BuildContext context,Function callback) async {
    // final strings = AppLocalizations.of(context);

    return showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
            padding: const EdgeInsets.all(24),
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Row(
                  children: [
                    Text('Are you sure you want to log out?',style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.black,fontWeightDelta: 2,fontSizeDelta: 1)),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    TextButton(
                      child: Text('Cancel',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600)),

                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    SizedBox(width: 8,),
                    TextButton(
                      child: Text('Logout'),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.amber,
                          textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        callback();
                      },
                    )
                  ],
                )

              ],
            ),
          );
        }
    );
  }

  static Future<void> timePickerDialog(BuildContext context,Function callback) async {
    // final strings = AppLocalizations.of(context);
    int min = 0;
    int sec = 0;

    return showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
            padding: const EdgeInsets.all(18),
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Row(
                  children: [
                    Text('Please choose the time',style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.black,fontWeightDelta: 2,fontSizeDelta: 1)),
                  ],
                ),

                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hms,
                      onTimerDurationChanged: (value) {
                        int hour = value.inHours;
                        int tempMin = (hour * 60) + (value.inMinutes - (value.inHours * 60));
                        sec = value.inSeconds - (tempMin * 60);

                        if(tempMin >= 255) {
                          min = 255;
                          sec = 0;
                        }else
                          min = tempMin;
                      }
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    TextButton(
                      child: Text('Cancel',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    SizedBox(width: 8,),
                    TextButton(
                      child: Text('Submit'),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: const Color.fromRGBO(234, 170, 68, 1),
                          textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        callback(min, sec);
                      },
                    )
                  ],
                )

              ],
            ),
          );
        }
    );

    // return showDialog<void>(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   builder: (BuildContext context) {
    //     return AlertDialog(contentPadding: EdgeInsets.only(left: 16,top: 16,bottom: 16,right: 16),
    //       content: Text('Are you sure want to leave quotes?',style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.black,fontWeightDelta: 2,fontSizeDelta: 1)),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('Leave',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600)),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             callback();
    //           },
    //         ),
    //         TextButton(
    //           style: TextButton.styleFrom(
    //           primary: Colors.white,
    //           backgroundColor: Colors.amber,
    //           textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
    //           child: Text('Continue',),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  static Future<void> numberPickerDialog(BuildContext context,Function callback) async {
    // final strings = AppLocalizations.of(context);
    int number = 0;

    return showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
            padding: const EdgeInsets.all(18),
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Row(
                  children: [
                    Text('Please choose a value',style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.black,fontWeightDelta: 2,fontSizeDelta: 1)),
                  ],
                ),

                NumberPickerWidget(callback: (value){
                  number = value;
                },),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    TextButton(
                      child: Text('Cancel',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    SizedBox(width: 8,),
                    TextButton(
                      child: Text('Submit'),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: const Color.fromRGBO(234, 170, 68, 1),
                          textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        callback(number);
                      },
                    )
                  ],
                )

              ],
            ),
          );
        }
    );

  }

}


showProgress(BuildContext context) {
  BuildContext dialogContext;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      dialogContext = context;
      return Dialog(
        backgroundColor: Colors.transparent,elevation: 0.0,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )
            ),
//            new Text("Loading"),
          ],
        ),
      );
    },
  );

}

class FunkyOverlay extends StatefulWidget {

  const FunkyOverlay({ Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child:  Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
        ),
      ),
    );
  }
}


class NumberPickerWidget extends StatefulWidget {
  final Function callback;
  const NumberPickerWidget({Key key,this.callback}) : super(key: key);

  @override
  _NumberPickerWidgetState createState() => _NumberPickerWidgetState();
}

class _NumberPickerWidgetState extends State<NumberPickerWidget> {

  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: NumberPicker(
        value: number,
        minValue: 0,
        maxValue: 101,
        step: 1,
        haptics: true,
        infiniteLoop: false,
        onChanged: (value) {
          setState(() {
            number = value;
          });
          this.widget.callback(value);
        },
      ),
    );
  }
}
