
import 'dart:convert';

import 'package:bio/model/bio_provider.dart';
import 'package:bio/network/repository.dart';
import 'package:bio/res/styles.dart';
import 'package:bio/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import 'home.dart';

class ControlPage extends StatefulWidget {
  final Function sendData;

  const ControlPage({Key key, this.sendData}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  BioProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BioProvider>(context,listen: false);


    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Consumer<BioProvider>(
          builder: (_, snapshot,__) {
            return Column(
              children: [
                SizedBox(height: 4,),

                buildDurationIntensity(provider.hydrogelPump,(){
                  _sendMessage('#ID=0&int=${provider.hydrogelPump.level}&min=${provider.hydrogelPump.time.split(':').first}&sec=${provider.hydrogelPump.time.split(':').last}&cmd=${provider.hydrogelPump.status ? 1 : 0}**');
                }),

                buildCurrentDesired(provider.hgExtruderTemp, (){
                  _sendMessage('#ID=1&goal=${provider.hgExtruderTemp.level}&cmd=${provider.hgExtruderTemp.status ? 1 : 0}**');
                }),

                buildCurrentDesiredWithCoolHeat(provider.bedCoolHeat, (){
                  _sendMessage('#ID=2&bedfun=${provider.bedCoolHeat.cool ? 1: 0 }&goal=${provider.bedCoolHeat.level}&cmd=${provider.bedCoolHeat.status ? 1 : 0}**');
                }),

                buildCurrentDesired(provider.heating, (){
                  _sendMessage('#ID=3&goal=${provider.heating.level}&cmd=${provider.heating.status ? 1 : 0}**');
                }),

                buildCurrentDesired(provider.co2, (){
                  int level = provider.co2.level;
                 _sendMessage('#ID=4&goal=$level&cmd=${provider.co2.status ? 1 : 0}**');
                }),

                buildMagnet(provider.magnet, (){
                  // #ID=5&freq=536&pwma=52&pwmb=12&    min=32&sec=49&cmd=0**
                  _sendMessage('#ID=5&freq=${provider.magnet.level}&pwma=${provider.magnet.pwaA}&pwmb=${provider.magnet.pwaB}&min=${provider.magnet.time.split(':').first}&sec=${provider.magnet.time.split(':').last}&cmd=${provider.magnet.status ? 1 : 0}**');
                }),

                buildDuration(provider.fanInput, (){
                  _sendMessage('#ID=6&min=${provider.fanInput.time.split(':').first}&sec=${provider.fanInput.time.split(':').last}&cmd=${provider.fanInput.status ? 1 : 0}**');
                }),

                buildDuration(provider.fanOutput, (){
                  _sendMessage('#ID=7&min=${provider.fanOutput.time.split(':').first}&sec=${provider.fanOutput.time.split(':').last}&cmd=${provider.fanOutput.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.chamberUV, (){
                  _sendMessage('#ID=8&int=${provider.chamberUV.level}&min=${provider.chamberUV.time.split(':').first}&sec=${provider.chamberUV.time.split(':').last}&cmd=${provider.chamberUV.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.plantLED, (){
                  _sendMessage('#ID=9&int=${provider.plantLED.level}&min=${provider.plantLED.time.split(':').first}&sec=${provider.plantLED.time.split(':').last}&cmd=${provider.plantLED.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.crossLinkUV, (){
                  _sendMessage('#ID=10&int=${provider.crossLinkUV.level}&min=${provider.crossLinkUV.time.split(':').first}&sec=${provider.crossLinkUV.time.split(':').last}&cmd=${provider.crossLinkUV.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.plasma, (){
                  _sendMessage('#ID=11&int=${provider.plasma.level}&min=${provider.plasma.time.split(':').first}&sec=${provider.plasma.time.split(':').last}&cmd=${provider.plasma.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.pi20, (){
                  _sendMessage('#ID=12&int=${provider.pi20.level}&min=${provider.pi20.time.split(':').first}&sec=${provider.pi20.time.split(':').last}&cmd=${provider.pi20.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.electrospinPump, (){
                  _sendMessage('#ID=13&int=${provider.electrospinPump.level}&min=${provider.electrospinPump.time.split(':').first}&sec=${provider.electrospinPump.time.split(':').last}&cmd=${provider.electrospinPump.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.electrospinPower, (){
                  _sendMessage('#ID=14&int=${provider.electrospinPower.level}&min=${provider.electrospinPower.time.split(':').first}&sec=${provider.electrospinPower.time.split(':').last}&cmd=${provider.electrospinPower.status ? 1 : 0}**');
                }),

                buildDurationIntensity(provider.laser, (){
                  _sendMessage('#ID=15&int=${provider.laser.level}&min=${provider.laser.time.split(':').first}&sec=${provider.laser.time.split(':').last}&cmd=${provider.laser.status ? 1 : 0}**');
                }),

                SizedBox(height: 70,),
              ],
            );
          }
      ),
    );
  }

  void _sendMessage(String text) async {
    print('command $text sent.');

    if (text.length > 0) {
      try {

        widget.sendData(text);

        Repository().addRecord('device parameter','$text').then((value) {
          print('record sent.');
        }).catchError((value){
          print('catchError $value');
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Error. Please check connection',Colors.red));
        print('send error $e');
        // Ignore error, but notify state
        setState(() {});
      }
    }
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

  Widget buildDurationIntensity(Parameter param,Function callback) {
    return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(83, 80, 120, 1),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async{
                  bool canVibrate = await Vibrate.canVibrate;
                  if(canVibrate){
                    var _type = FeedbackType.light;
                    Vibrate.feedback(_type);
                  }
                  setState(() {
                    param.status = !param.status;
                  });
                  callback();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: param.status ? Colors.lightGreenAccent[400] : Colors.white70,
                              borderRadius: BorderRadius.circular(8)
                            ),
                            width: 55, height: 4,
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Text(param.name,style: TextStyle(color: Colors.white,fontSize: 18),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      DialogHelper.timePickerDialog(context, (int hour, int min){
                        setState(() {
                          param.time = "$hour:$min";
                        });
                        callback();
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Duration',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${param.time.split(':').first}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4,left: 2),
                              child: Text('m',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(':',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w800),),
                            ),

                            Text('${param.time.split(':').last}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4,left: 2),
                              child: Text('s',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      DialogHelper.numberPickerDialog(context, (int number){
                        setState(() {
                          param.level = number;
                        });
                        callback();
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Intensity',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${param.level}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4,left: 2),
                              child: Text('%',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      );
  }

  Widget buildDuration(Parameter param, Function callback) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(83, 80, 120, 1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async{
                bool canVibrate = await Vibrate.canVibrate;
                if(canVibrate){
                  var _type = FeedbackType.light;
                  Vibrate.feedback(_type);
                }
                setState(() {
                  param.status = !param.status;
                });
                callback();
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: param.status ? Colors.lightGreenAccent[400] : Colors.white70,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          width: 55, height: 4,
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(param.name,style: TextStyle(color: Colors.white,fontSize: 18),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    DialogHelper.timePickerDialog(context, (int hour, int min){
                      setState(() {
                        param.time = "$hour:$min";
                      });
                      callback();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Duration',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${param.time.split(':').first}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4,left: 2),
                            child: Text('h',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(':',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w800),),
                          ),

                          Text('${param.time.split(':').last}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4,left: 2),
                            child: Text('m',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget buildCurrentDesired(Parameter param, Function callback) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(83, 80, 120, 1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async{
                bool canVibrate = await Vibrate.canVibrate;
                if(canVibrate){
                  var _type = FeedbackType.light;
                  Vibrate.feedback(_type);
                }
                setState(() {
                  param.status = !param.status;
                });
                callback();
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: param.status ? Colors.lightGreenAccent[400] : Colors.white70,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          width: 55, height: 4,
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(param.name,style: TextStyle(color: Colors.white,fontSize: 18),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    DialogHelper.numberPickerDialog(context, (int number){
                      setState(() {
                        param.level = number;
                      });
                      callback();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Desired Value',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${param.level}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4,left: 2),
                            child: Text('%',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Temperature',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${param.current}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4,left: 2),
                          child: Text('°C',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                        ),

                      ],
                    ),
                  ],
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget buildCurrentDesiredWithCoolHeat(Parameter param, Function callback) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(83, 80, 120, 1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async{
                bool canVibrate = await Vibrate.canVibrate;
                if(canVibrate){
                  var _type = FeedbackType.light;
                  Vibrate.feedback(_type);
                }
                setState(() {
                  param.status = !param.status;
                });
                callback();
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: param.status ? Colors.lightGreenAccent[400] : Colors.white70,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          width: 55, height: 4,
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async{
                    bool canVibrate = await Vibrate.canVibrate;
                    if(canVibrate){
                      var _type = FeedbackType.light;
                      Vibrate.feedback(_type);
                    }
                    setState(() {
                      param.status = !param.status;
                    });
                    callback();
                  },
                  child: Text(param.name,style: TextStyle(color: Colors.white,fontSize: 18),)
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      param.cool = !param.cool;
                    });
                    callback();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 4),
                              decoration: BoxDecoration(
                                  border: param.cool ? Border.all(color: Colors.white,width: 1) : Border.all(color: Colors.transparent,width: 0),
                                  color: param.cool ? Colors.blueAccent : Colors.blueAccent.withOpacity(.3),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))
                              ),child: Text('COOL',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: param.cool ? FontWeight.w600 : FontWeight.w400),)),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 4),
                              decoration: BoxDecoration(
                                  border: !param.cool ? Border.all(color: Colors.white,width: 1) : Border.all(color: Colors.transparent,width: 0),
                                  color: !param.cool? Colors.red : Colors.red.withOpacity(.3),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8))
                              ),child: Text('HEAT',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: !param.cool ? FontWeight.w600 : FontWeight.w400),)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    DialogHelper.numberPickerDialog(context, (int number){
                      setState(() {
                        param.level = number;
                      });
                      callback();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Desired Value',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${param.level}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4,left: 2),
                            child: Text('%',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Temperature',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${param.current}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4,left: 2),
                          child: Text('°C',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                        ),

                      ],
                    ),
                  ],
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget buildMagnet(Parameter param,Function callback) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(83, 80, 120, 1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async{
                bool canVibrate = await Vibrate.canVibrate;
                if(canVibrate){
                  var _type = FeedbackType.light;
                  Vibrate.feedback(_type);
                }
                setState(() {
                  param.status = !param.status;
                });
                callback();
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: param.status ? Colors.lightGreenAccent[400] : Colors.white70,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              width: 55, height: 4,
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Text(param.name,style: TextStyle(color: Colors.white,fontSize: 18),),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        DialogHelper.numberPickerDialog(context, (int number){
                          setState(() {
                            param.level = number;
                          });
                          callback();
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Freq',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${param.level}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4,left: 2),
                                child: Text('%',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    DialogHelper.timePickerDialog(context, (int hour, int min){
                      setState(() {
                        param.time = "$hour:$min";
                      });
                      callback();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Duration',style: TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${param.time.split(':').first}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4,left: 2),
                            child: Text('m',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(':',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w800),),
                          ),

                          Text('${param.time.split(':').last}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4,left: 2),
                            child: Text('s',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        DialogHelper.numberPickerDialog(context, (int number){
                          setState(() {
                            param.pwaA = number;
                          });
                          callback();
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Intensity A',style: TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w600),),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${param.pwaA}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4,left: 2),
                                child: Text('%',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 22,),
                    InkWell(
                      onTap: (){
                        DialogHelper.numberPickerDialog(context, (int number){
                          setState(() {
                            param.pwaB = number;
                          });
                          callback();
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Intensity B',style: TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.w600),),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${param.pwaB}',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4,left: 2),
                                child: Text('%',style: TextStyle(color: Colors.white54,fontSize: 14,fontWeight: FontWeight.w600),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

}
