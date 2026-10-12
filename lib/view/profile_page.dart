
import 'package:bio/model/bio_provider.dart';
import 'package:bio/network/repository.dart';
import 'package:bio/res/styles.dart';
import 'package:bio/utils/dialog.dart';
import 'package:bio/utils/shared_pref.dart';
import 'package:bio/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var _selectedDate;
  var _selectedNozel;

  int bioTypeSegmentValue = 0;
  final Map<int, Widget> bioTypeSegment = const <int, Widget>{
    0: Text("FDM"),
    1: Text("Hydrogel")
  };

  int scafoldTypeSegmentValue = 0;
  final Map<int, Widget> scafoldTypeSegment = const <int, Widget>{
    0: Text("Cartilage"),
    1: Text("Bone"),
    2: Text("Skin")
  };

  List<dynamic> nozelItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nozelItems.add({
      'color': Color.fromRGBO(236, 182, 142, 1),
      'gauge':32
    });

    nozelItems.add({
      'color': Color.fromRGBO(154, 120, 161, 1),
      'gauge':31
    });

    nozelItems.add({
      'color': Color.fromRGBO(230, 226, 154, 1),
      'gauge':30
   });

    nozelItems.add({
      'color': Color.fromRGBO(204, 88, 71, 1),
      'gauge': 29
    });

    nozelItems.add({
      'color': Color.fromRGBO(131,190,218, 1),
      'gauge': 28
    });

    nozelItems.add({
      'color': Color.fromRGBO(185,184,172, 1),
      'gauge': 27
    });

    nozelItems.add({
      'color': Color.fromRGBO(189,168,154, 1),
      'gauge': 26
    });

    nozelItems.add({
      'color': Color.fromRGBO(231,179,126, 1),
      'gauge': 25
    });

    nozelItems.add({
      'color': Color.fromRGBO(38,73,133, 1),
      'gauge': 23
    });

    nozelItems.add({
      'color': Color.fromRGBO(130,125,117, 1),
      'gauge': 22
    });

    nozelItems.add({
      'color': Color.fromRGBO(147,176,114, 1),
      'gauge': 21
    });

    nozelItems.add({
      'color': Color.fromRGBO(218,214,138, 1),
      'gauge': 20
    });

    nozelItems.add({
      'color': Color.fromRGBO(198,183,144, 1),
      'gauge': 19
    });

    nozelItems.add({
      'color': Color.fromRGBO(207,134,156, 1),
      'gauge': 18
    });

    nozelItems.add({
      'color': Colors.white,
      'gauge': 16
    });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 4,),

          card(),

          deviceCard(),

          SizedBox(height: 70,),

        ],
      ),
    );
  }


  Widget card() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(83, 80, 120, 1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            CircleAvatar(
              child: Icon(Icons.person,color: Colors.white,size: 60,),
              radius: 40,
              backgroundColor: Colors.white70.withOpacity(.3),
            ),
            SizedBox(height: 10,),
            Text('MOC',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 21),),
            Divider(color: Colors.white54,),

            InkWell(
              onTap: (){
                logOutDialog(context,(){
                  SharedPref().clear();
                  Navigator.pushReplacementNamed(context, '/signin');
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.login,color: Colors.white,),
                  SizedBox(width: 12,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('Logout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 17),),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget deviceCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(83, 80, 120, 1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Device',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),),
            SizedBox(height: 16,),

            Text('Bio printing type',style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w600,fontSize: 15),),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoSlidingSegmentedControl(
                    groupValue: bioTypeSegmentValue,
                    children: bioTypeSegment,
                    backgroundColor: Colors.white70.withOpacity(.3),
                    onValueChanged: (i) {
                      setState(() {
                        bioTypeSegmentValue = i;
                      });
                    }),
              ],
            ),

            Divider(color: Colors.white24,),

            SizedBox(height: 4,),

            Text('Scafold type',style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w600,fontSize: 15),),

            SizedBox(height: 6,),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoSlidingSegmentedControl(
                    groupValue: scafoldTypeSegmentValue,
                    children: scafoldTypeSegment,
                    backgroundColor: Colors.white70.withOpacity(.3),
                    onValueChanged: (i) {
                      setState(() {
                        scafoldTypeSegmentValue = i;
                      });
                    }),
              ],
            ),

            Divider(color: Colors.white24,),

            SizedBox(height: 4,),

            Text('Date',style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w600,fontSize: 15),),

            GestureDetector(
              onTap: (){

                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2030),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.dark(),
                      child: child,
                    );
                  },
                ).then((value){

                  if (value == null) {
                    return;
                  }
                  setState(() {
                    final f = new DateFormat('yyyy-MM-dd'); // hh:mm
                    _selectedDate = f.format(value);
                  });

                });

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${_selectedDate ?? 'choose date'}',style: TextStyle(color: Colors.white,),),
                ],
              ),
            ),

            if(bioTypeSegmentValue == 1)
            Divider(color: Colors.white24,),
            if(bioTypeSegmentValue == 1)
            SizedBox(height: 4,),
            if(bioTypeSegmentValue == 1)
            Text('Printer nozel dimeter',style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w600,fontSize: 15),),
            if(bioTypeSegmentValue == 1)
            GestureDetector(
              onTap: (){
                nozelDialog(context,(value){
                  setState(() {
                    _selectedNozel = value;
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${_selectedNozel ?? 'choose nozel'}',style: TextStyle(color: Colors.white,),),
                  Icon(Icons.arrow_drop_down,color: Colors.white,)
                ],
              ),
            ),

            Center(
              child: InkWell(
                onTap: () {
                  var items = {
                    'bioPrintingType':bioTypeSegmentValue,
                    'scafoldType':scafoldTypeSegmentValue,
                    'date':_selectedDate,
                    'nozelDimeter':_selectedNozel
                  };
                  _updateInfoTap(items.toString());
                  print('$items');
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(top: 16.0),
                  child: Text('  SUBMIT  ', style: TextStyle(
                      fontWeight: FontWeight.w700, color: Color.fromRGBO(234, 170, 68, 1))),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: const Color.fromRGBO(234, 170, 68, 1),width: 1.2)
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }


  Future<void> logOutDialog(BuildContext context,Function callback) async {
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

  Future<void> nozelDialog(BuildContext context,Function callback) async {
    // final strings = AppLocalizations.of(context);

    return showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
            padding: const EdgeInsets.all(24),
            // height: 150,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Row(
                    children: [
                      Text('Choose Nozel Dimeter',style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.black,fontWeightDelta: 2,fontSizeDelta: 1)),
                    ],
                  ),

                  SizedBox(height: 16,),

                  for(var item in nozelItems)
                  ListTile(
                    onTap: (){
                      Navigator.pop(context);
                      callback(item['gauge']);
                    },
                    leading: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item['color']
                      ),
                    ),
                    title: Text('${item['gauge']}',style: TextStyle(fontWeight: FontWeight.w600),),
                    trailing: Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //
                  //     Row(
                  //       children: [
                  //         Container(
                  //           width: 20,
                  //           height: 20,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: item['color']
                  //           ),
                  //         ),
                  //
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text('${item['gauge']}',style: TextStyle(fontWeight: FontWeight.w600),),
                  //         ),
                  //       ],
                  //     ),
                  //
                  //     Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                  //   ],
                  // ),

                ],
              ),
            ),
          );
        }
    );
  }

  _checkValidation(){

    if(_selectedDate== null){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Please select date',Colors.blue));
      return false;
    }

    if(bioTypeSegmentValue == 1)
    if(_selectedNozel == null){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Please select nozel',Colors.blue));
      return false;
    }

    return true;

  }

  _updateInfoTap(String info) {

    if(!_checkValidation()){
      return;
    }

    _showProgress();
    Repository().updateDeviceInfo(info).then((value) {

      _removeProgress();

      try{
        ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Submitted.',Colors.blue));

      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('$e',Colors.red));
      }

    }).catchError((value){
      _removeProgress();
      print('$value');
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Error. try again!',Colors.red));
    });
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
