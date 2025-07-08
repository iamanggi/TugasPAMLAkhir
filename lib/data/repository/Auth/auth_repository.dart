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
          key: "authToken", //harus sama dengan yang di service
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
      final response = await _serviceHttpClient.post(
        "register",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        final registerResponse = jsonResponse['message'] as String;
        log("Registration successful: ${registerResponse}");
        return Right(registerResponse);
      } else {
        log("Registration failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Registration failed");
      }
    } catch (e) {
      log("Error in registration: $e");
      return Left("An error occurred while registering.");
    }
  }
}
