class ProfileModel {
  bool _status;
  Data _data;

  bool get status => _status;
  Data get data => _data;

  ProfileModel({
      bool status, 
      Data data}){
    _status = status;
    _data = data;
}

  ProfileModel.fromJson(dynamic json) {
    _status = json["status"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

class Data {
  String _userid;
  String _email;
  String _pass;
  String _phone;
  String _lastlogin;
  String _recordcount;
  String _lastBackup;

  String get userid => _userid;
  String get email => _email;
  String get pass => _pass;
  String get phone => _phone;
  String get lastlogin => _lastlogin;
  String get recordcount => _recordcount;
  String get lastBackup => _lastBackup;

  Data({
      String userid, 
      String email, 
      String pass, 
      String phone, 
      String lastlogin, 
      String recordcount, 
      String lastBackup}){
    _userid = userid;
    _email = email;
    _pass = pass;
    _phone = phone;
    _lastlogin = lastlogin;
    _recordcount = recordcount;
    _lastBackup = lastBackup;
}

  Data.fromJson(dynamic json) {
    _userid = json["userid"];
    _email = json["email"];
    _pass = json["pass"];
    _phone = json["phone"];
    _lastlogin = json["lastlogin"];
    _recordcount = json["recordcount"];
    _lastBackup = json["last_backup"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = _userid;
    map["email"] = _email;
    map["pass"] = _pass;
    map["phone"] = _phone;
    map["lastlogin"] = _lastlogin;
    map["recordcount"] = _recordcount;
    map["last_backup"] = _lastBackup;
    return map;
  }

}