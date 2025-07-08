import 'dart:convert';

// Response Model untuk List Pemeliharaan
class PemeliharaanListResponseModel {
  final bool? success;
  final String? message;
  final List<PemeliharaanModel>? data;
  final PaginationModel? pagination;

  PemeliharaanListResponseModel({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory PemeliharaanListResponseModel.fromJson(String str) =>
      PemeliharaanListResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemeliharaanListResponseModel.fromMap(Map<String, dynamic> json) =>
      PemeliharaanListResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<PemeliharaanModel>.from(
                json["data"].map((x) => PemeliharaanModel.fromMap(x))),
        pagination: json["pagination"] == null
            ? null
            : PaginationModel.fromMap(json["pagination"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data?.map((x) => x.toMap()).toList(),
        "pagination": pagination?.toMap(),
      };
}

// Response Model untuk Single Pemeliharaan
class PemeliharaanResponseModel {
  final bool? success;
  final String? message;
  final PemeliharaanModel? data;

  PemeliharaanResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory PemeliharaanResponseModel.fromJson(String str) =>
      PemeliharaanResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemeliharaanResponseModel.fromMap(Map<String, dynamic> json) =>
      PemeliharaanResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PemeliharaanModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data?.toMap(),
      };
}

// Response Model untuk Form Create/Edit
class PemeliharaanFormResponseModel {
  final bool? success;
  final String? message;
  final PemeliharaanFormData? data;

  PemeliharaanFormResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory PemeliharaanFormResponseModel.fromJson(String str) =>
      PemeliharaanFormResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemeliharaanFormResponseModel.fromMap(Map<String, dynamic> json) =>
      PemeliharaanFormResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PemeliharaanFormData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data?.toMap(),
      };
}

// Model untuk Pemeliharaan
class PemeliharaanModel {
  final int? id;
  final String? judul;
  final String? deskripsi;
  final int? lokasiId;
  final int? laporanId;
  final String? tanggalMulai;
  final String? tanggalSelesai;
  final String? status;
  final String? catatan;
  final String? foto;
  final String? createdAt;
  final String? updatedAt;
  final LokasiModel? lokasi;
  final LaporanModel? laporan;

  PemeliharaanModel({
    this.id,
    this.judul,
    this.deskripsi,
    this.lokasiId,
    this.laporanId,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.status,
    this.catatan,
    this.foto,
    this.createdAt,
    this.updatedAt,
    this.lokasi,
    this.laporan,
  });

  factory PemeliharaanModel.fromJson(String str) =>
      PemeliharaanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemeliharaanModel.fromMap(Map<String, dynamic> json) =>
      PemeliharaanModel(
        id: json["id"],
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        lokasiId: json["lokasi_id"],
        laporanId: json["laporan_id"],
        tanggalMulai: json["tanggal_mulai"],
        tanggalSelesai: json["tanggal_selesai"],
        status: json["status"],
        catatan: json["catatan"],
        foto: json["foto"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        lokasi: json["lokasi"] == null
            ? null
            : LokasiModel.fromMap(json["lokasi"]),
        laporan: json["laporan"] == null
            ? null
            : LaporanModel.fromMap(json["laporan"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "judul": judul,
        "deskripsi": deskripsi,
        "lokasi_id": lokasiId,
        "laporan_id": laporanId,
        "tanggal_mulai": tanggalMulai,
        "tanggal_selesai": tanggalSelesai,
        "status": status,
        "catatan": catatan,
        "foto": foto,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "lokasi": lokasi?.toMap(),
        "laporan": laporan?.toMap(),
      };

  PemeliharaanModel copyWith({
    int? id,
    String? judul,
    String? deskripsi,
    int? lokasiId,
    int? laporanId,
    String? tanggalMulai,
    String? tanggalSelesai,
    String? status,
    String? catatan,
    String? foto,
    String? createdAt,
    String? updatedAt,
    LokasiModel? lokasi,
    LaporanModel? laporan,
  }) {
    return PemeliharaanModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      lokasiId: lokasiId ?? this.lokasiId,
      laporanId: laporanId ?? this.laporanId,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
      foto: foto ?? this.foto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lokasi: lokasi ?? this.lokasi,
      laporan: laporan ?? this.laporan,
    );
  }
}

// Model untuk Form Data
class PemeliharaanFormData {
  final PemeliharaanModel? pemeliharaan;
  final List<LokasiModel>? lokasis;
  final List<LaporanModel>? laporans;

  PemeliharaanFormData({
    this.pemeliharaan,
    this.lokasis,
    this.laporans,
  });

  factory PemeliharaanFormData.fromMap(Map<String, dynamic> json) =>
      PemeliharaanFormData(
        pemeliharaan: json["pemeliharaan"] == null
            ? null
            : PemeliharaanModel.fromMap(json["pemeliharaan"]),
        lokasis: json["lokasis"] == null
            ? null
            : List<LokasiModel>.from(
                json["lokasis"].map((x) => LokasiModel.fromMap(x))),
        laporans: json["laporans"] == null
            ? null
            : List<LaporanModel>.from(
                json["laporans"].map((x) => LaporanModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "pemeliharaan": pemeliharaan?.toMap(),
        "lokasis": lokasis?.map((x) => x.toMap()).toList(),
        "laporans": laporans?.map((x) => x.toMap()).toList(),
      };
}

// Model untuk Lokasi
class LokasiModel {
  final int? id;
  final String? namaLokasi;
  final String? alamat;
  final String? deskripsi;
  final double? latitude;
  final double? longitude;
  final String? createdAt;
  final String? updatedAt;

  LokasiModel({
    this.id,
    this.namaLokasi,
    this.alamat,
    this.deskripsi,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory LokasiModel.fromMap(Map<String, dynamic> json) => LokasiModel(
        id: json["id"],
        namaLokasi: json["nama_lokasi"],
        alamat: json["alamat"],
        deskripsi: json["deskripsi"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama_lokasi": namaLokasi,
        "alamat": alamat,
        "deskripsi": deskripsi,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

// Model untuk Laporan
class LaporanModel {
  final int? id;
  final String? judul;
  final String? deskripsi;
  final String? status;
  final String? kategori;
  final String? foto;
  final String? createdAt;
  final String? updatedAt;

  LaporanModel({
    this.id,
    this.judul,
    this.deskripsi,
    this.status,
    this.kategori,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  factory LaporanModel.fromMap(Map<String, dynamic> json) => LaporanModel(
        id: json["id"],
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        status: json["status"],
        kategori: json["kategori"],
        foto: json["foto"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "judul": judul,
        "deskripsi": deskripsi,
        "status": status,
        "kategori": kategori,
        "foto": foto,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

// Model untuk Pagination
class PaginationModel {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;

  PaginationModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  factory PaginationModel.fromMap(Map<String, dynamic> json) =>
      PaginationModel(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        total: json["total"],
        from: json["from"],
        to: json["to"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "per_page": perPage,
        "total": total,
        "from": from,
        "to": to,
      };
}