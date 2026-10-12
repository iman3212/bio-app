
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/shared_pref.dart';
import 'app_exception.dart';

class ServiceHelper {

  Future<dynamic> post(String url,var data) async {

    var responseJson;
    try{

      print('url: $url  --  data: $data\n');


      String token = await SharedPref().getString(SharedPref.token);

      final response  = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 20));
      print('res: ${response.body}');
      responseJson = _returnResponse(response);

    } on TimeoutException catch (_){
      throw Exception("TimedOut");
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the post");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
    print('==============\n  post service url: $url \n=> $responseJson \n*********\n ');
    return responseJson;
  }

  Future<dynamic> get(String url,[var data]) async {

    var responseJson;
    try{
      String token = await SharedPref().getString(SharedPref.token);

      final response  = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          // 'Content-Type': 'application/json; charset=UTF-8',
          // 'Accept': 'application/json'
          // ,
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));
      responseJson = _returnResponse(response);
      // responseJson = response.statusCode;
      // debugPrint('ressss:' + response.bodyBytes.);
      // var _profileImage = Image.memory(response.bodyBytes).image;
      // debugPrint('s123  ' + _profileImage.toString());

    } on TimeoutException catch (_){
      throw Exception("TimedOut");
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the post");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
    print('==============\n  get service url: $url \n=> $responseJson \n');
    return responseJson;
  }

//   Future<dynamic> delete(String url,[var data]) async {
//
//     var responseJson;
//     try{
// //      String token = await SharedPref().getString(SharedPref.token);
// //      String id = await SharedPref().getString(SharedPref.id);
//
//       final response  = await http.delete(
//         url,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
// //          'authorization': '${ServiceURL.AUTHORIZATION_HEADER}',
// //          'x-access-token': '$token',
//         },
//       ).timeout(const Duration(seconds: 20));
//       responseJson = _returnResponse(response);
//
//     } on TimeoutException catch (_){
//       throw Exception("TimedOut");
//     } on SocketException {
//       throw Exception('No Internet connection');
//     } on HttpException {
//       throw Exception("Couldn't find the post");
//     } on FormatException {
//       throw Exception("Bad response format 👎");
//     }
//     print('==============\n  delete service url: $url \n=> $responseJson \n');
//     return responseJson;
//   }

  dynamic _returnResponse(http.Response response,[dynamic data,String url]) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'status:${response.statusCode} - urll $url  - b:$data - ${response.body} ');
    // 'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

}
