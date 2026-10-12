import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/shared_pref.dart';

class SendData {
  var uri = "http://148.251.224.230:5000";


  Future<http.Response> postData(postUrl, post_body) async {
    var post_url = "$uri/$postUrl";
    print(post_url);
    var url = Uri.parse(post_url);
    String token = await SharedPref().getString(SharedPref.token);

    var response = await http.post(url,
        body: post_body,
        headers: token.isEmpty
            ? {"Content-type": "application/json"}
            : {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        });
    return response;
  }

  Future<http.Response> getData(getUrl) async {
    String token = await SharedPref().getString(SharedPref.token);

    var get_url = "$uri/$getUrl";
    print(get_url);
    var url = Uri.parse(get_url);
    var response = await http.get(url, headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    });
    return response;
  }

  Future<http.Response> uploadData(uploadUrl, filename,customheader,customHeader) async {
    bool customheadeer=customheader;

    var upload_url = '$uri/$uploadUrl';
    var url = Uri.parse(upload_url);
    String token = await SharedPref().getString(SharedPref.token);
    var req = await http.MultipartRequest('POST', url);
    req.headers.addAll(customheadeer? {"Authorization": "Bearer $token","title":"$customHeader"} :{"Authorization": "Bearer $token"});
    req.files.add(await http.MultipartFile.fromPath('file', filename));

    var res = await http.Response.fromStream(await req.send());
    

    return res;
  }

}
