// lib/models/prediction_result.dart

class PredictionResult {
  final String prediksi;
  final String kepercayaan;
  final String deskripsi;
  final String saran;

  PredictionResult({
    required this.prediksi,
    required this.kepercayaan,
    required this.deskripsi,
    required this.saran,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediksi: json['prediksi'] ?? 'Tidak Diketahui',
      kepercayaan: json['kepercayaan'] ?? '0%',
      deskripsi: json['deskripsi'] ?? '-',
      saran: json['saran'] ?? '-',
    );
  }
}