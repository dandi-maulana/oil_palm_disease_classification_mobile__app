// lib/models/history_item.dart

class HistoryItem {
  final int id;
  final String gambarUrl;
  final String hasilPrediksi;
  final String kepercayaan;
  final String waktu;
  final double durasiPengujian;
  final String namaPenguji; // <-- TAMBAHKAN
  final String lokasiPengujian; // <-- TAMBAHKAN
  final String namaFile; // <-- TAMBAHKAN

  HistoryItem({
    required this.id,
    required this.gambarUrl,
    required this.hasilPrediksi,
    required this.kepercayaan,
    required this.waktu,
    required this.durasiPengujian,
    required this.namaPenguji, // <-- TAMBAHKAN
    required this.lokasiPengujian, // <-- TAMBAHKAN
    required this.namaFile, // <-- TAMBAHKAN
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      gambarUrl: json['gambar_path'] ?? '',
      hasilPrediksi: json['hasil_prediksi'] ?? 'N/A',
      kepercayaan: json['kepercayaan'] ?? 'N/A',
      waktu: json['created_at'] ?? '',
      durasiPengujian: (json['durasi_pengujian'] as num? ?? 0.0).toDouble(),
      namaPenguji: json['nama_penguji'] ?? 'Tidak Diketahui', // <-- TAMBAHKAN
      lokasiPengujian: json['lokasi_pengujian'] ?? 'Tidak Diketahui', // <-- TAMBAHKAN
      namaFile: json['nama_file'] ?? 'N/A', // <-- TAMBAHKAN
    );
  }
}