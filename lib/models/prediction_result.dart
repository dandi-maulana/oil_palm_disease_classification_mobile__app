// lib/models/prediction_result.dart

class PredictionResult {
  final String prediksi;
  final String kepercayaan;
  final String deskripsi;
  final String saran;
  final String durasi; // <-- TAMBAHKAN INI
  final String waktuSelesai; // <-- TAMBAHKAN INI

  PredictionResult({
    required this.prediksi,
    required this.kepercayaan,
    required this.deskripsi,
    required this.saran,
    required this.durasi, // <-- TAMBAHKAN INI
    required this.waktuSelesai, // <-- TAMBAHKAN INI
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediksi: json['prediksi'] ?? 'Tidak Diketahui',
      kepercayaan: json['kepercayaan'] ?? '0%',
      deskripsi: json['deskripsi'] ?? '-',
      saran: json['saran'] ?? '-',
      durasi: json['durasi'] ?? '- detik', // <-- TAMBAHKAN INI
      waktuSelesai: json['waktu_selesai'] ?? '-', // <-- TAMBAHKAN INI
    );
  }
}