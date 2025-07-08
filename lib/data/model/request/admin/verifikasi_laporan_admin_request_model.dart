import 'dart:convert';

class VerifikasiLaporanRequestModel {
  final bool isAccepted;
  final String? alasan;

  VerifikasiLaporanRequestModel({
    required this.isAccepted,
    this.alasan,
  });

  Map<String, dynamic> toMap() {
    return {
      'is_accepted': isAccepted,
      'alasan': alasan,
    };
  }

  String toJson() => json.encode(toMap());
}
