import 'dart:convert';

// Request Model untuk Create Pemeliharaan
class CreatePemeliharaanRequestModel {
  final String judul;
  final String deskripsi;
  final int lokasiId;
  final int? laporanId;
  final String tanggalMulai;
  final String? tanggalSelesai;
  final String status;
  final String? catatan;
  final String? foto;

  CreatePemeliharaanRequestModel({
    required this.judul,
    required this.deskripsi,
    required this.lokasiId,
    this.laporanId,
    required this.tanggalMulai,
    this.tanggalSelesai,
    required this.status,
    this.catatan,
    this.foto,
  });

  factory CreatePemeliharaanRequestModel.fromJson(String str) =>
      CreatePemeliharaanRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreatePemeliharaanRequestModel.fromMap(Map<String, dynamic> json) =>
      CreatePemeliharaanRequestModel(
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        lokasiId: json["lokasi_id"],
        laporanId: json["laporan_id"],
        tanggalMulai: json["tanggal_mulai"],
        tanggalSelesai: json["tanggal_selesai"],
        status: json["status"],
        catatan: json["catatan"],
        foto: json["foto"],
      );

  Map<String, dynamic> toMap() => {
        "judul": judul,
        "deskripsi": deskripsi,
        "lokasi_id": lokasiId,
        "laporan_id": laporanId,
        "tanggal_mulai": tanggalMulai,
        "tanggal_selesai": tanggalSelesai,
        "status": status,
        "catatan": catatan,
        "foto": foto,
      };

  CreatePemeliharaanRequestModel copyWith({
    String? judul,
    String? deskripsi,
    int? lokasiId,
    int? laporanId,
    String? tanggalMulai,
    String? tanggalSelesai,
    String? status,
    String? catatan,
    String? foto,
  }) {
    return CreatePemeliharaanRequestModel(
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      lokasiId: lokasiId ?? this.lokasiId,
      laporanId: laporanId ?? this.laporanId,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
      foto: foto ?? this.foto,
    );
  }
}

// Request Model untuk Update Pemeliharaan
class UpdatePemeliharaanRequestModel {
  final String? judul;
  final String? deskripsi;
  final int? lokasiId;
  final int? laporanId;
  final String? tanggalMulai;
  final String? tanggalSelesai;
  final String? status;
  final String? catatan;
  final String? foto;

  UpdatePemeliharaanRequestModel({
    this.judul,
    this.deskripsi,
    this.lokasiId,
    this.laporanId,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.status,
    this.catatan,
    this.foto,
  });

  factory UpdatePemeliharaanRequestModel.fromJson(String str) =>
      UpdatePemeliharaanRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdatePemeliharaanRequestModel.fromMap(Map<String, dynamic> json) =>
      UpdatePemeliharaanRequestModel(
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        lokasiId: json["lokasi_id"],
        laporanId: json["laporan_id"],
        tanggalMulai: json["tanggal_mulai"],
        tanggalSelesai: json["tanggal_selesai"],
        status: json["status"],
        catatan: json["catatan"],
        foto: json["foto"],
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (judul != null) map["judul"] = judul;
    if (deskripsi != null) map["deskripsi"] = deskripsi;
    if (lokasiId != null) map["lokasi_id"] = lokasiId;
    if (laporanId != null) map["laporan_id"] = laporanId;
    if (tanggalMulai != null) map["tanggal_mulai"] = tanggalMulai;
    if (tanggalSelesai != null) map["tanggal_selesai"] = tanggalSelesai;
    if (status != null) map["status"] = status;
    if (catatan != null) map["catatan"] = catatan;
    if (foto != null) map["foto"] = foto;
    return map;
  }

  UpdatePemeliharaanRequestModel copyWith({
    String? judul,
    String? deskripsi,
    int? lokasiId,
    int? laporanId,
    String? tanggalMulai,
    String? tanggalSelesai,
    String? status,
    String? catatan,
    String? foto,
  }) {
    return UpdatePemeliharaanRequestModel(
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      lokasiId: lokasiId ?? this.lokasiId,
      laporanId: laporanId ?? this.laporanId,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
      foto: foto ?? this.foto,
    );
  }
}

// Request Model untuk Filter/Search Pemeliharaan
class PemeliharaanFilterRequestModel {
  final String? search;
  final String? status;
  final String? dateRange;
  final int? lokasiId;
  final int? page;
  final int? limit;

  PemeliharaanFilterRequestModel({
    this.search,
    this.status,
    this.dateRange,
    this.lokasiId,
    this.page,
    this.limit,
  });

  factory PemeliharaanFilterRequestModel.fromJson(String str) =>
      PemeliharaanFilterRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PemeliharaanFilterRequestModel.fromMap(Map<String, dynamic> json) =>
      PemeliharaanFilterRequestModel(
        search: json["search"],
        status: json["status"],
        dateRange: json["date_range"],
        lokasiId: json["lokasi_id"],
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toMap() => {
        "search": search,
        "status": status,
        "date_range": dateRange,
        "lokasi_id": lokasiId,
        "page": page,
        "limit": limit,
      };

  Map<String, String> toQueryParams() {
    final map = <String, String>{};
    if (search != null) map["search"] = search!;
    if (status != null) map["status"] = status!;
    if (dateRange != null) map["date_range"] = dateRange!;
    if (lokasiId != null) map["lokasi_id"] = lokasiId.toString();
    if (page != null) map["page"] = page.toString();
    if (limit != null) map["limit"] = limit.toString();
    return map;
  }

  PemeliharaanFilterRequestModel copyWith({
    String? search,
    String? status,
    String? dateRange,
    int? lokasiId,
    int? page,
    int? limit,
  }) {
    return PemeliharaanFilterRequestModel(
      search: search ?? this.search,
      status: status ?? this.status,
      dateRange: dateRange ?? this.dateRange,
      lokasiId: lokasiId ?? this.lokasiId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  factory PemeliharaanFilterRequestModel.withDefault() {
    return PemeliharaanFilterRequestModel(
      page: 1,
      limit: 10,
    );
  }
}