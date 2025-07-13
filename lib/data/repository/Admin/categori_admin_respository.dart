import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tilik_desa/data/model/request/admin/categori_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/categori_admin_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class CategoryRepository {
  final ServiceHttpClient _httpClient;
  CategoryRepository(this._httpClient);

  Future<Either<String, List<CategoryDataModel>>> getCategories() async {
    try {
      final response = await _httpClient.get('categories');
      log("📥 getCategories - Status: ${response.statusCode}");
      log("📥 getCategories - Body: ${response.body}");
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'] ?? [];
        final categories =
            list.map((e) => CategoryDataModel.fromMap(e)).toList();
        return Right(categories);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil kategori');
      }
    } catch (e) {
      log("❌ Error in getCategories: $e");
      return Left('Terjadi kesalahan saat mengambil kategori.');
    }
  }

  Future<Either<String, CategoryDataModel>> addCategory(
    CategoryRequestModel request,
  ) async {
    try {
      // Debug: Log data yang akan dikirim
      log("📤 addCategory - Request Data: ${request.toMap()}");
      
      final response = await _httpClient.postWithToken(
        'admin/categories',
        request.toMap(),
      );
      
      log("📤 addCategory - Status: ${response.statusCode}");
      log("📤 addCategory - Body: ${response.body}");
      
      // Handle different status codes
      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];
        return Right(CategoryDataModel.fromMap(data));
      } else if (response.statusCode == 500) {
        // Server error - log more details
        log("❌ Server Error 500 - Response: ${response.body}");
        try {
          final decoded = json.decode(response.body);
          return Left(decoded['message'] ?? 'Server error: Failed to create category');
        } catch (e) {
          return Left('Server error: Unable to process request');
        }
      } else {
        // Other client errors
        try {
          final decoded = json.decode(response.body);
          return Left(decoded['message'] ?? 'Gagal menambahkan kategori');
        } catch (e) {
          return Left('Error: Status ${response.statusCode}');
        }
      }
    } catch (e) {
      log("❌ Error in addCategory: $e");
      return Left('Terjadi kesalahan saat menambahkan kategori: $e');
    }
  }

  Future<Either<String, CategoryDataModel>> updateCategory(
    int id,
    CategoryRequestModel request,
  ) async {
    try {
      // GANTI dari put() menjadi putWithToken()
      final response = await _httpClient.putWithToken(
        'admin/categories/$id',
        request.toMap(),
      );
      
      log("✏️ updateCategory - Status: ${response.statusCode}");
      log("✏️ updateCategory - Body: ${response.body}");
      
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        final data = decoded['data'];
        return Right(CategoryDataModel.fromMap(data));
      } else {
        return Left(decoded['message'] ?? 'Gagal mengupdate kategori');
      }
    } catch (e) {
      log("❌ Error in updateCategory: $e");
      return Left('Terjadi kesalahan saat mengupdate kategori.');
    }
  }

  Future<Either<String, bool>> deleteCategory(int id) async {
    try {
      // GANTI dari delete() menjadi deleteWithToken()
      final response = await _httpClient.deleteWithToken('admin/categories/$id');
      
      log("🗑 deleteCategory - Status: ${response.statusCode}");
      log("🗑 deleteCategory - Body: ${response.body}");
      
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(decoded['message'] ?? 'Gagal menghapus kategori');
      }
    } catch (e) {
      log("❌ Error in deleteCategory: $e");
      return Left('Terjadi kesalahan saat menghapus kategori.');
    }
  }
}