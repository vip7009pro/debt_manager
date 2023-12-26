import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:debt_manager/controller/LocalDataAccess.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

// ignore: camel_case_types
class API_Request {
  // ignore: non_constant_identifier_names
  static Future<Map<String,dynamic>> api_query(String command, Map<String, dynamic> data) async {
    String url = '';
    url = await LocalDataAccess.getVariable('serverIP');    
    url = 'http://14.160.33.94:3003/api';
    var dio = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 10000), // in ms
        receiveTimeout: const Duration(milliseconds: 10000),
        sendTimeout: const Duration(milliseconds: 1000),
        responseType: ResponseType.json,
        followRedirects: false,
        validateStatus: (status) {
          return true;
        }));
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    String savedToken = await LocalDataAccess.getVariable("token");    
    print(savedToken);
    data['token_string'] = savedToken;
    final body = {'command': command, 'DATA': data};    
    try {
      final response = await dio.post(url, data: jsonEncode(body));
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 404) {
        return {'tk_status': 'NG', 'message': 'Không tìm thấy dữ liệu'};        
      } else {
        return {'tk_status': 'NG', 'message': 'Kết nối có vấn đề'};        
      }
    } on DioException catch (e) {      
      return {'tk_status': 'NG', 'message': '$e'};
    } catch (e) {     
      return {'tk_status': 'NG', 'message': '$e'};
    }
  }
}
