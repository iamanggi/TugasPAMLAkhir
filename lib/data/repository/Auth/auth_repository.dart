import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tilik_desa/data/model/request/auth/login_request_model.dart';
import 'package:tilik_desa/data/model/request/auth/register_request_model.dart';
import 'package:tilik_desa/data/model/response/auth/register_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  Future<Either<String, RegisterResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "login",
        requestModel.toMap(),
      );
      log("Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");
      
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final loginResponse = RegisterResponseModel.fromMap(jsonResponse);
        await secureStorage.write(
          key: "authToken",
          value: loginResponse.data!.token,
        );
        await secureStorage.write(
          key: "userRole",
          value: loginResponse.data!.tokenType,
        );
        await secureStorage.write(
          key: "userName",
          value: loginResponse.data!.user?.nama ?? "Pengguna",
        );
        log("Login successful: ${loginResponse.message}");
        return Right(loginResponse);
      } else {
        log("Login failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      log("Error in login: $e");
      return Left("An error occurred while logging in.");
    }
  }

  Future<Either<String, String>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      // Log request data sebelum dikirim
      final requestData = requestModel.toMap();
      log("=== REGISTER REQUEST DEBUG ===");
      log("Endpoint: register");
      log("Request Data: ${json.encode(requestData)}");
      log("Request Data Keys: ${requestData.keys.toList()}");
      
      // Validasi data request
      requestData.forEach((key, value) {
        log("$key: $value (${value.runtimeType})");
      });
      
      final response = await _serviceHttpClient.post(
        "register",
        requestData,
      );
      
      // Log response lengkap
      log("=== REGISTER RESPONSE DEBUG ===");
      log("Status Code: ${response.statusCode}");
      log("Response Headers: ${response.headers}");
      log("Response Body: ${response.body}");
      log("Response Body Length: ${response.body.length}");
      
      // Cek apakah response body kosong
      if (response.body.isEmpty) {
        log("ERROR: Response body is empty!");
        return Left("Empty response from server");
      }
      
      final jsonResponse = json.decode(response.body);
      log("Parsed JSON Response: $jsonResponse");
      
      // Cek berbagai kemungkinan status code sukses
      if (response.statusCode == 201 || response.statusCode == 200) {
        final registerResponse = jsonResponse['message'] as String;
        log("Registration successful: $registerResponse");
        return Right(registerResponse);
      } else {
        // Log error detail
        log("Registration failed with status: ${response.statusCode}");
        log("Error message: ${jsonResponse['message']}");
        log("Full error response: $jsonResponse");
        
        // Cek apakah ada validation errors
        if (jsonResponse.containsKey('errors')) {
          log("Validation errors: ${jsonResponse['errors']}");
        }
        
        return Left(jsonResponse['message'] ?? "Registration failed with status ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      log("=== REGISTER ERROR DEBUG ===");
      log("Error in registration: $e");
      log("Stack trace: $stackTrace");
      return Left("An error occurred while registering: $e");
    }
  }
}