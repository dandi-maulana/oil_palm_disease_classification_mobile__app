// lib/screens/history_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/history_item.dart';
import '../api/api_service.dart';
import '../config.dart';

class HistoryDetailScreen extends StatefulWidget {
  final int historyId;

  const HistoryDetailScreen({super.key, required this.historyId});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  late Future<HistoryItem> _historyDetailFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _historyDetailFuture = _apiService.fetchHistoryDetail(widget.historyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat'),
        backgroundColor: const Color(0xFF1e3a8a),
      ),
      body: FutureBuilder<HistoryItem>(
        future: _historyDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final item = snapshot.data!;
            final imageUrl = 'http://$API_IP:8000/storage/${item.gambarUrl}';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(height: 250, color: Colors.grey[200], child: const Icon(Icons.error)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Card(
                    elevation: 4,
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Hasil Prediksi', item.hasilPrediksi, isTitle: true,
                            valueColor: item.hasilPrediksi == 'Daun Sehat' ? Colors.green[800] : Colors.red[800]),
                          _buildDetailRow('Tingkat Kepercayaan', item.kepercayaan),
                          const Divider(height: 24),
                          _buildDetailRow('Nama Penguji', item.namaPenguji),
                          _buildDetailRow('Lokasi Pengujian', item.lokasiPengujian),
                          const Divider(height: 24),
                          _buildDetailRow('Waktu Analisis', formatDateTime(item.waktu)),
                          _buildDetailRow('Durasi', '${item.durasiPengujian.toStringAsFixed(4)} detik'),
                           _buildDetailRow('Nama File Asli', item.namaFile),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('Tidak ada data ditemukan.'));
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isTitle = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 15)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: isTitle ? 20 : 16,
                fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      const monthNames = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
      return '${dateTime.day} ${monthNames[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) { return dateTimeString; }
  }
}