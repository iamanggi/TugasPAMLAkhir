import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceHttpClient {
  final String baseUrl = 'http://10.0.2.2:8888/api/';
  //final String baseUrl = 'http://192.168.0.111:8888/api/';
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
    final url = Uri.parse('$baseUrl$endPoint');
    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
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
    String endPoint,
    Map<String, dynamic> body, {
    Map<String, File>? files, // Ubah menjadi nullable
  }) async {
    try {
      final token = await secureStorage.read(key: 'authToken');
      final url = Uri.parse('$baseUrl$endPoint');

      final request = http.MultipartRequest('POST', url);
      
      // Add headers
      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add fields
      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add files if not null
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
      final response = await http.Response.fromStream(streamedResponse);
      
      return response;
    } catch (e) {
      print('Error in postMultipart: $e');
      rethrow;
    }
  }

  // PUT multipart dengan token
  Future<http.Response> putMultipart(
    String endPoint,
    Map<String, dynamic> body, {
    Map<String, File>? files, // Ubah menjadi nullable
  }) async {
    try {
      final token = await secureStorage.read(key: 'authToken');
      final url = Uri.parse('$baseUrl$endPoint');

      final request = http.MultipartRequest('POST', url);
      
      // Add headers
      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.fields['_method'] = 'PUT';

      // Add fields
      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add files if not null
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
}