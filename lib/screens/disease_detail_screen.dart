// lib/screens/disease_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/disease_sample.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseSample disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disease.name),
        backgroundColor: const Color(0xFF1e3a8a),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Gambar Daun dengan Efek Gradasi ---
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  // === PERBAIKAN DI SINI: Menggunakan Image.network ===
                  image: NetworkImage(disease.imagePath),
                  fit: BoxFit.cover,
                  // Menambahkan error builder jika gambar gagal dimuat
                  onError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        disease.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Kartu Informasi ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    title: 'Penjelasan Penyakit',
                    content: disease.description,
                    icon: Icons.info_outline,
                    color: Colors.blue[800]!,
                  ),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    title: 'Solusi & Penanganan',
                    content: disease.solution,
                    icon: Icons.lightbulb_outline,
                    color: Colors.green[700]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat kartu informasi yang konsisten
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}