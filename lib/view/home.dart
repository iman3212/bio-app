
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bio/model/bio_provider.dart';
import 'package:bio/view/convert_page.dart';
import 'package:bio/view/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../res/styles.dart';
import '../utils/dialog.dart';
import 'camera_page.dart';
import 'control_page.dart';
import 'pair_devices.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State createState() => new HomeState();
}

class HomeState extends State<Home> {

  final globalKey = GlobalKey<ScaffoldState>();

  // SensorsModel sensorsModel = SensorsModel('-', '-', '-', '-', '-', '0');
  BluetoothDevice device;
  StreamSubscription streamSubscription;

  bool _report = false;
  var lastMsgDate;


  List<String> pages = [];
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pages.add('Control');
    pages.add('Camera');
    pages.add('Profile');
    pages.add('Convert');
  }

  @override
  void dispose() {
    super.dispose();
    disconnectDevice();
  }

  disconnectDevice(){
    if(streamSubscription != null){
      streamSubscription.pause();
      streamSubscription.cancel();
    }
    if(device != null) {
      device.disconnect();
      device = null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        key: globalKey,
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: buildPageView(),
      ),
    );
  }

  Widget buildNotConnect() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text('You are not connected to the device',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.grey[400]),),

              GestureDetector(
                onTap: () => _navigateToBluetoothPired(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(top: 16.0),
                  child: Text('Connect to device', style: TextStyle(
                      fontWeight: FontWeight.w700, color: Color.fromRGBO(234, 170, 68, 1))),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: const Color.fromRGBO(234, 170, 68, 1),width: 1.2)
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  }

  Widget buildPageView() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView(
          children: <Widget>[
            device == null ? buildNotConnect() : StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) {
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    return ControlPage(sendData: (String data){
                      _sendMessage(data);
                    },);
                    break;
                  case BluetoothDeviceState.disconnected:
                    return buildNotConnect();
                    break;
                  default:
                    return Container();
                    break;
                }
              },
            ),
            CameraPage(),
            ProfilePage(),
            ConvertPage()
          ],
          pageSnapping: true,
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (i){
            setState(() {
              _currentPage = i;

            });
          },
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(234, 170, 68, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(width: 6,),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                onPressed: (){
                  _pageController.jumpToPage(0);
                },
                child: Text(pages[0],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: Colors.white,
                width: .7,
                height: 24,
              ),

              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                onPressed: (){
                  _pageController.jumpToPage(1);
                },
                child: Text(pages[1],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: Colors.white,
                width: .7,
                height: 24,
              ),

              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                onPressed: (){
                  _pageController.jumpToPage(2);
                },
                child: Text(pages[2],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: Colors.white,
                width: .7,
                height: 24,
              ),

              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                onPressed: (){
                  _pageController.jumpToPage(3);
                },
                child: Text(pages[3],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
              ),

              SizedBox(width: 6,),

            ],
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        // toolbarHeight: btIsConnected ? 110 : 62,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 16, right: 0, top: 0),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Image.asset('assets/images/logo.png',width: 100,),
                  ),

                  Container(
                    padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 24),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(234, 170, 68, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16)
                      )
                    ),
                    child: device == null ? IconButton(icon: Icon(Icons.bluetooth,color: Colors.white), onPressed: () => _navigateToBluetoothPired()) : StreamBuilder<BluetoothDeviceState>(
                      stream: device.state,
                      initialData: BluetoothDeviceState.connecting,
                      builder: (c, snapshot) {
                        switch (snapshot.data) {
                          case BluetoothDeviceState.connected:
                            return IconButton(icon: Icon(Icons.bluetooth_connected,color: Colors.white), onPressed: () => _navigateToBluetoothPired());
                            break;
                          case BluetoothDeviceState.disconnected:
                            return IconButton(icon: Icon(Icons.bluetooth,color: Colors.white), onPressed: () => _navigateToBluetoothPired());
                            break;
                          default:
                            return IconButton(icon: Icon(Icons.bluetooth,color: Colors.white), onPressed: () => _navigateToBluetoothPired());
                            break;
                        }
                      },
                    ),
                  )

                ],
              ),

              // if(btIsConnected)
              // Column(
              //   children: [
                  SizedBox(height: 12,),
              //
              //     GestureDetector(
              //       onTap: (){
              //         if(_currentPage == 1){
              //           _pageController.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
              //         }else{
              //           _pageController.nextPage(duration: Duration(milliseconds: 200),curve: Curves.ease);
              //         }
              //       },
              //       child: Row(
              //         children: [
                        Row(
                          children: [
                            Text(pages[_currentPage],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 19),),
                          ],
                        ),
              //         ],
              //       ),
              //     ),
              //
              //     SizedBox(height: 12,),
              //
              //     Row(
              //       children: [
              //         for(int i = 0 ; i < pages.length ; i ++)
              //           AnimatedContainer(
              //           margin: const EdgeInsets.only(left: 0,right: 3),
              //           width: 45,
              //           height: 2.2,
              //           color: _currentPage == i ? Colors.white : Colors.white30,
              //           duration: Duration(milliseconds: 300),
              //           curve: Curves.ease,
              //         ),
              //       ],
              //     ),
              //   ],
              // ),

            ],
          ),
        ),
      );
  }

  OverlayEntry overlayEntry;

  _showProgress() {
    overlayEntry = OverlayEntry(builder: (c) {
      return FunkyOverlay();
    });
    Overlay.of(context).insert(overlayEntry);
  }

  _removeProgress() {
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

  //
  // void _fetchData() async{
  //
  //   var _image = NetworkImage(capture);
  //
  //   _image.resolve(ImageConfiguration()).addListener(
  //     ImageStreamListener(
  //           (info, call) {
  //
  //         info.image.toByteData().then((value) {
  //           print('Networkimage is fully loaded and saved ::: ${value.buffer.asFloat32List()}');
  //         });
  //
  //         // do something
  //       },
  //     ),
  //   );
  //
  // }
  //
  // _detection() {
  //
  //   setState(() {
  //     showReport = false;
  //   });
  //
  //   _showProgress();
  //   Timer(Duration(seconds: 2),(){
  //     _removeProgress();
  //     setState(() {
  //       showReport = true;
  //     });
  //   });
  // }



  Future<bool> _checkDeviceBluetoothIsOn() async {
    return await FlutterBlue.instance.isOn;
  }

  _navigateToBluetoothPired() async {

    if(device != null){
      disconnectDevice();
      return;
    }

    bool isOn = await _checkDeviceBluetoothIsOn();

    if(!isOn){
      globalKey.currentState.showSnackBar(_showSnackBar('Please turn on Bluetooth.',Colors.red));
      return;
    }

    device = await Navigator.of(context).push( MaterialPageRoute(builder: (context) => PairedDevices()));

    if (device != null) {
      print('Discovery -> selected ' + device.name);
      _connectToDevice();
    } else {
      print('Discovery -> no device selected');
    }

  }


  void _connectToDevice() {

    _showProgress();

    device.connect(timeout: Duration(seconds: 4)).then((value) async {

      try{

        setState(() {
          _report = false;
        });

        await device.discoverServices();

        _removeProgress();

        device.services.listen((event) async{
          String _messageBuffer = '';
          await event.last.characteristics.first.setNotifyValue(true);
          streamSubscription = event.last.characteristics.first.value.listen((msg) async {

            Future<bool> createBuffer(charInt){
              var input = String.fromCharCode(charInt);

              if(input.toString().contains('#')){
                _messageBuffer = '';
              }

              _messageBuffer += input;

              if( _messageBuffer.contains('**')) {
                print('buffer $_messageBuffer');
                _parseReceiveData(_messageBuffer);
                _messageBuffer = '';
              }
              return Future.value(true);
            }

            msg.forEach((charCode) async {
              await createBuffer(charCode);
            });

          });

        });

      }catch(e){
        print('ex1 $e');
      }
    }).timeout(Duration(seconds: 4)).catchError((onError){
      _removeProgress();
      print('connecting Cannot connect, exception: $onError');
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Can not connect to device.',Colors.red));
    });

  }

  _sendMessage(String text) async {
    print('command $text sent.');
    device.services.listen((event) async {
      List<int> bytes = utf8.encode(text);
      event.last.characteristics.first.write(bytes);
    });
  }


  _parseReceiveData(streamData) {

    try{

      var data = streamData.replaceAll('#', '').replaceAll('**', '').split('&');

      print('^^ len ${data.length}');
      if(data.length == 4) { // sensor data

        improveItem(String item){
          var temp = item.split('=').last.trim();
          if(temp.isEmpty)
            return '--';
          return temp;
        }

        Provider.of<BioProvider>(context,listen: false).sensorData(
            int.parse(data[0].split('=').last),
            int.parse(data[1].split('=').last),
            int.parse(data[2].split('=').last),
            int.parse(data[3].split('=').last));

      }

      if(!this.mounted)
        return;

      setState(() {});

    }catch(e){
      print('parse $e');
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString();
  }

  _backupTap() async{

    // bool connection = await connectivityChecker();
    //
    // if(!connection){
    //   final snackBar = showSnackBar('No internet connection!');
    //   globalKey.currentState.showSnackBar(snackBar);
    //   return;
    // }
    //
    // bool hasError = false;
    // int record = await dbHelper.getCount();
    //
    // if(record == 0)
    //   return;
    //
    //
    // _showProgress();
    // dbHelper.getRecordList().then((value) async {
    //
    //   for(int i = 0; i < value.length; i++){
    //
    //     await Repository().addRecord(value[i].desc,value[i].data).then((value) {
    //
    //     }).catchError((value){
    //       print('catchError $value');
    //       hasError = true;
    //     });
    //
    //   }
    //
    //   _removeProgress();
    //   if(!hasError){
    //     dbHelper.deleteAll();
    //
    //
    //     final snackBar = showSnackBar('Backup was successful');
    //     globalKey.currentState.showSnackBar(snackBar);
    //
    //     recordCount = 0;
    //     setState(() {});
    //   }else{
    //     final snackBar = showSnackBar('Backup Error!');
    //     globalKey.currentState.showSnackBar(snackBar);
    //   }
    //
    // });

  }

}