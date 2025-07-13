import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as _storage;
import 'package:tilik_desa/data/model/request/user/profil_update_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/profil_update_user_response_model.dart';

class ServiceHttpClient {
  //  final String baseUrl = 'http://10.0.2.2:8888/api/';
  final String baseUrl = 'http://192.168.0.111:8888/api/';
  final secureStorage = const FlutterSecureStorage();

  // POST tanpa token
  Future<http.Response> post(String endPoint, Map body) async {
    final url = Uri.parse('$baseUrl$endPoint');
    return await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  // POST dengan token
  Future<http.Response> postWithToken(String endPoint, Map body) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');

    print('[DEBUG] POST with token - URL: $url');
    print('[DEBUG] POST with token - Token: $token');
    
    return await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  // PUT tanpa token
  Future<http.Response> put(String endPoint, Map body) async {
    final url = Uri.parse('$baseUrl$endPoint');
    return await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  // PUT dengan token
  Future<http.Response> putWithToken(String endPoint, Map body) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');

    print('[DEBUG] PUT with token - URL: $url');
    print('[DEBUG] PUT with token - Token: $token');
    
    return await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  // GET dengan token 
  Future<http.Response> get(String endPoint) async {
    final token = await secureStorage.read(key: 'authToken');
    print('[DEBUG] GET - Token yang dibaca: $token');
    print('[DEBUG] GET - Token null? ${token == null}');
    print('[DEBUG] GET - Token kosong? ${token?.isEmpty}');
    
    if (token == null || token.isEmpty) {
      print('[ERROR] Token tidak ditemukan!');
      throw Exception('Token tidak ditemukan');
    }
    
    final url = Uri.parse('$baseUrl$endPoint');
    print('[DEBUG] GET - URL: $url');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    
    print('[DEBUG] GET - Headers: $headers');
    
    try {
      final response = await http.get(url, headers: headers);
      print('[DEBUG] GET - Response status: ${response.statusCode}');
      print('[DEBUG] GET - Response body: ${response.body}');
      return response;
    } catch (e) {
      print('[ERROR] GET - Exception: $e');
      rethrow;
    }
  }


  // GET tanpa token
  Future<http.Response> getWithoutToken(String endPoint) async {
    final url = Uri.parse('$baseUrl$endPoint');
    return await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  // DELETE tanpa token
  Future<http.Response> delete(String endPoint) async {
    final url = Uri.parse('$baseUrl$endPoint');
    return await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  // DELETE dengan token
  Future<http.Response> deleteWithToken(String endPoint) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');

    print('[DEBUG] DELETE with token - URL: $url');
    print('[DEBUG] DELETE with token - Token: $token');
    
    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  // PATCH dengan token
  Future<http.Response> patchWithToken(String endPoint, Map body) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');

    print('[DEBUG] PATCH with token - URL: $url');
    print('[DEBUG] PATCH with token - Token: $token');
    
    return await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  // POST multipart (upload) dengan token

  Future<http.Response> postMultipart(
    String endpoint,
    Map<String, dynamic> fields, {
    Map<String, File>? files,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    final token = await secureStorage.read(key: 'authToken');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (files != null) {
      for (final entry in files.entries) {
        final file = entry.value;
        final multipartFile = await http.MultipartFile.fromPath(
          entry.key,
          file.path,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }


  // PUT multipart dengan token
  Future<http.Response> putMultipart(
    String endPoint,
    Map<String, dynamic> body, {
    Map<String, File>? files,
  }) async {
    try {
      final token = await secureStorage.read(key: 'authToken');
      final url = Uri.parse('$baseUrl$endPoint');

      final request = http.MultipartRequest('POST', url);

      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.fields['_method'] = 'PUT';

      print('[DEBUG] PUT multipart - URL: $url');
      print('[DEBUG] PUT multipart - Token: $token');
      print('[DEBUG] PUT multipart - Headers: ${request.headers}');

      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      if (files != null) {
        for (final entry in files.entries) {
          try {
            final file = await http.MultipartFile.fromPath(
              entry.key,
              entry.value.path,
            );
            request.files.add(file);
          } catch (e) {
            print('Error adding file ${entry.key}: $e');
          }
        }
      }

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      print('Error in putMultipart: $e');
      rethrow;
    }
  }
  
  // Method untuk test koneksi dengan token
  Future<bool> testTokenValidity() async {
    try {
      final token = await secureStorage.read(key: 'authToken');
      if (token == null || token.isEmpty) {
        print('[TEST] Token tidak ditemukan');
        return false;
      }
      
      final url = Uri.parse('${baseUrl}user'); 
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      
      print('[TEST] Token validity test - Status: ${response.statusCode}');
      print('[TEST] Token validity test - Body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('[TEST] Error testing token: $e');
      return false;
    }
  }

  Future<http.Response> postMultipartWithToken(
  String endpoint, {
  required Map<String, dynamic> fields,
  File? photoFile,
}) async {
  final token = await secureStorage.read(key: "authToken");
  final uri = Uri.parse('$baseUrl$endpoint');

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..headers['Accept'] = 'application/json';

  fields.forEach((key, value) {
    request.fields[key] = value;
  });

  if (photoFile != null) {
    final fileName = photoFile.path.split('/').last;
    request.files.add(await http.MultipartFile.fromPath('photo', photoFile.path));
  }

  final streamedResponse = await request.send();
  return await http.Response.fromStream(streamedResponse);
}
}