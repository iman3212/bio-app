class Record {
  int _id;
  String _desc;
  var _time;
  var _data;

  Record(this._desc, this._time, this._data);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  get time => _time;

  set time(value) {
    _time = value;
  }

  get data => _data;

  set data(value) {
    _data = value;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = _id;
    map['desc'] = _desc;
    map['time'] = _time;
    map['data'] = _data;

    return map;
  }

  // Extract a Note object from a Map object
  Record.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._desc = map['desc'];
    this._time = map['time'];
    this._data = map['data'];
  }
}
