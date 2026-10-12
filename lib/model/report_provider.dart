import 'package:flutter/material.dart';

class ReportModel{
  String type;
  String mcValue;
  String mcRounded;
  String baseIntensity;
  String quesryIntensity;
  String date;
  String time;

  ReportModel(this.type, this.mcValue, this.mcRounded, this.baseIntensity,
      this.quesryIntensity, this.date, this.time);

}

class ReportProvider with ChangeNotifier {

  List<ReportModel> _list = [];
  get list => _list;

  void setList(List<ReportModel>  records) {
    _list = records;
    notifyListeners();
  }

}
