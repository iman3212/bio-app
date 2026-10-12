
import 'package:flutter/cupertino.dart';

class Parameter {
  int id;
  String name;
  bool status;
  int current;
  int level;
  String time;
  bool cool;

  // only for magnet field
  int pwaA;
  int pwaB;

  Parameter({this.id, this.name, this.status, this.current, this.level, this.time, this.cool, this.pwaA = 0, this.pwaB = 0});

  // Map<String, dynamic> toJson() {
  //   var map = <String, dynamic>{};
  //   map["id"] = id;
  //   map["name"] = name;
  //   map["status"] = status;
  //   map["current"] = current;
  //   map["level"] = level;
  //   map["time"] = time;
  //   return map;
  // }

}

class BioProvider with ChangeNotifier{

  Parameter _hydrogelPump = Parameter(id: 0,name: 'Hydrogel Pump',status: false, level: 0,time: '0:0');
  Parameter _hgExtruderTemp = Parameter(id: 1,name: 'Hydrogel Extruder Temp',status: false,current: 0,level: 0);
  Parameter _bedCoolHeat = Parameter(id: 2,name: 'Bed (Cool/Heat)',status: false,current: 0,level: 0, cool: false);
  Parameter _heating = Parameter(id: 3,name: 'Chember Temp',status: false,current: 0,level: 0);
  Parameter _co2 = Parameter(id: 4,name: 'Carbon Dioxide(CO2)',status: false,current: 0, level: 0, time: '0:0');
  Parameter _magnet = Parameter(id: 5,name: 'Magnetic Filed',status: false, level: 0, time: '0:0', pwaA: 0, pwaB: 0);
  Parameter _fanInput = Parameter(id: 6,name: 'Input Fan',status: false, level: 0, time: '0:0');
  Parameter _fanOutput = Parameter(id: 7,name: 'Output Fan',status: false, level: 0, time: '0:0');
  Parameter _chamberUV = Parameter(id: 8,name: 'Chamber UV Sterilization',status: false, level: 0, time: '0:0');
  Parameter _plantLED = Parameter(id: 9,name: 'Chamber LED',status: false, level: 0, time: '0:0');
  Parameter _crossLinkUV = Parameter(id: 10,name: 'Cross Link UV',status: false, level: 0, time: '0:0');
  Parameter _plasma = Parameter(id: 11,name: 'Plasma',status: false, level: 0, time: '0:0');
  Parameter _pi20 = Parameter(id: 12,name: 'Piezoelectric',status: false, level: 0, time: '0:0');
  Parameter _electrospinPump = Parameter(id: 13,name: 'Electrospinning Pump',status: false, level: 0, time: '0:0');
  Parameter _electrospinPower = Parameter(id: 14,name: 'Electrospinning Power',status: false, level: 0, time: '0:0');
  Parameter _laser = Parameter(id: 15,name: 'Laser',status: false, level: 0, time: '0:0');

  Parameter get hydrogelPump => _hydrogelPump;

  set hydrogelPump(Parameter value) {
    _hydrogelPump = value;
    notifyListeners();
  }

  Parameter get hgExtruderTemp => _hgExtruderTemp;

  set hgExtruderTemp(Parameter value) {
    _hgExtruderTemp = value;
    notifyListeners();
  }

  Parameter get bedCoolHeat => _bedCoolHeat;

  set bedCoolHeat(Parameter value) {
    _bedCoolHeat = value;
    notifyListeners();
  }

  Parameter get heating => _heating;

  set heating(Parameter value) {
    _heating = value;
    notifyListeners();
  }

  Parameter get co2 => _co2;

  set co2(Parameter value) {
    _co2 = value;
    notifyListeners();
  }

  Parameter get magnet => _magnet;

  set magnet(Parameter value) {
    _magnet = value;
    notifyListeners();
  }

  Parameter get fanInput => _fanInput;

  set fanInput(Parameter value) {
    _fanInput = value;
    notifyListeners();
  }

  Parameter get fanOutput => _fanOutput;

  set fanOutput(Parameter value) {
    _fanOutput = value;
    notifyListeners();
  }

  Parameter get chamberUV => _chamberUV;

  set chamberUV(Parameter value) {
    _chamberUV = value;
    notifyListeners();
  }

  Parameter get plantLED => _plantLED;

  set plantLED(Parameter value) {
    _plantLED = value;
    notifyListeners();
  }

  Parameter get crossLinkUV => _crossLinkUV;

  set crossLinkUV(Parameter value) {
    _crossLinkUV = value;
    notifyListeners();
  }

  Parameter get plasma => _plasma;

  set plasma(Parameter value) {
    _plasma = value;
    notifyListeners();
  }

  Parameter get pi20 => _pi20;

  set pi20(Parameter value) {
    _pi20 = value;
    notifyListeners();
  }

  Parameter get electrospinPump => _electrospinPump;

  set electrospinPump(Parameter value) {
    _electrospinPump = value;
    notifyListeners();
  }

  Parameter get electrospinPower => _electrospinPower;

  set electrospinPower(Parameter value) {
    _electrospinPower = value;
    notifyListeners();
  }

  Parameter get laser => _laser;

  set laser(Parameter value) {
    _laser = value;
    notifyListeners();
  }

  sensorData(id1,id2,id3,id4) {
    _hgExtruderTemp.current = id1;
    _bedCoolHeat.current = id2;
    _heating.current = id3;
    _co2.current = id4;
    notifyListeners();
  }

// void clearTask(){
  //   _category = null;
  //   _suburb = null;
  //   _budget = null;
  //   _description = null;
  //   _executionDate = null;
  //   _attachments = [];
  //   isNew = true;
  //   taskId = null;
  //   _budgetIndex = null;
  //   _dateIndex = null;
  //   // notifyListeners();
  // }

}