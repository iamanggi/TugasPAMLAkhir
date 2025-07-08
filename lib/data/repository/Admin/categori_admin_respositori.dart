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
      final response = await _httpClient.post(
        'admin/categories',
        request.toMap(),
      );
      log("📤 addCategory - Status: ${response.statusCode}");
      log("📤 addCategory - Body: ${response.body}");

      final decoded = json.decode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = decoded['data'];
        return Right(CategoryDataModel.fromMap(data));
      } else {
        return Left(decoded['message'] ?? 'Gagal menambahkan kategori');
      }
    } catch (e) {
      log("❌ Error in addCategory: $e");
      return Left('Terjadi kesalahan saat menambahkan kategori.');
    }
  }

  Future<Either<String, CategoryDataModel>> updateCategory(
    int id,
    CategoryRequestModel request,
  ) async {
    try {
      final response = await _httpClient.put(
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
      final response = await _httpClient.delete('admin/categories/$id');
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
