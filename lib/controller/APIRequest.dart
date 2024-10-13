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
  //upload image to server from file path
  static Future<Map<String,dynamic>> uploadImage(String imagePath) async {
    String url = await LocalDataAccess.getVariable('serverIP');
    url = 'http://14.160.33.94:3003/uploadfile';
    var dio = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 10000), // in ms
        receiveTimeout: const Duration(milliseconds: 10000),
        sendTimeout: const Duration(milliseconds: 1000),
        responseType: ResponseType.json,  
        headers: {'Content-Type': 'multipart/form-data'},
        followRedirects: false,
        validateStatus: (status) {
          return true;
        }));
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    try {
      final response = await dio.post(url, data: {'image': imagePath});
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {'tk_status': 'NG', 'message': 'Failed to upload image'};
      }
    } on DioException catch (e) {
      return {'tk_status': 'NG', 'message': '$e'};
    } catch (e) {
      return {'tk_status': 'NG', 'message': '$e'};
    }
  }

 static Future<void> uploadFile2(String filePath) async {
  String uploadUrl = 'http://14.160.33.94:3003/uploadfile';
  Dio dio = Dio();

  // Tạo FormData để chứa file
  FormData formData = FormData.fromMap({
    "uploadfile": await MultipartFile.fromFile(filePath, filename: "upload.png"),
  });

  try {
    // Gửi request POST để upload file
    Response response = await dio.post(
      uploadUrl,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    if (response.statusCode == 200) {
      print("File uploaded successfully");
    } else {
      print("Failed to upload file");
    }
  } catch (e) {
    print("Error: $e");
  }
}


  static Future<Map<String, dynamic>> uploadQuery({
    required dynamic file,
    required String filename,
    required String uploadfoldername,
    List<String>? filenamelist,
  }) async {
    String uploadUrl = 'http://14.160.33.94:3003/uploadfile'; // Replace with your actual upload URL
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      "uploadedfile": await MultipartFile.fromFile(file.path, filename: filename),
      "filename": filename,
      "uploadfoldername": uploadfoldername,
      "token_string": await LocalDataAccess.getVariable('token'), // Assuming you have a method to get the token      
    });

    if (filenamelist != null) {
      formData.fields.add(MapEntry("newfilenamelist", jsonEncode(filenamelist)));
    }

    try {
      Response response = await dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {'tk_status': 'NG', 'message': 'Failed to upload file'};
      }
    } catch (e) {
      return {'tk_status': 'NG', 'message': '$e'};
    }
  }
}
