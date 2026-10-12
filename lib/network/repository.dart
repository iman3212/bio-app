
import '../model/profile_model.dart';

import 'service_helper.dart';
import 'service_url.dart';

class Repository {

  ServiceHelper _helper = ServiceHelper();

  Future<dynamic> login(String email, String pass) async {
    var data = <String, dynamic>{
      'username': email,
      'password': pass,
    };
    final response = await _helper.post(ServiceURL.LOGIN,data);
    return response;
  }

  Future<dynamic> getProfile() async {
    final response = await _helper.get(ServiceURL.PROFILE);
    return response;
  }

  Future<dynamic> addRecord(String desc, String record) async {
    var data = <String, dynamic>{
      'description': desc,
      'data': record,
    };
    final response = await _helper.post(ServiceURL.record,data);
    return response;
  }

Future<dynamic> updateDeviceInfo(String info) async {
  var data = <String, dynamic>{
    'device_info': info
  };
  final response = await _helper.post(ServiceURL.updatedeviceInfo,data);
  return response;
}

}
