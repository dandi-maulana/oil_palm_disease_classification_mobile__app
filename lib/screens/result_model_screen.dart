// lib/screens/result_model_screen.dart

import 'package:flutter/material.dart';

class ResultModelScreen extends StatelessWidget {
  const ResultModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Model AI'),
        backgroundColor: const Color(0xFF1e3a8a), // Biru tua
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Judul Halaman ---
            const Text(
              'Hasil dan Evaluasi Model',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1e3a8a),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Berikut adalah rincian performa dari model AI Dr. Sawit yang telah dilatih.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            // --- Visualisasi Grafik ---
            _buildSectionTitle('Visualisasi Tren Pelatihan'),
            _buildImageCard('assets/images/grafik_akurasi.png'),
            _buildImageCard('assets/images/grafik_loss.png'),
            const SizedBox(height: 20),

            // --- Confusion Matrix ---
            _buildSectionTitle('Confusion Matrix'),
            _buildImageCard('assets/images/confusion_matrix.png'),
            const SizedBox(height: 20),

            // --- Classification Report ---
            _buildSectionTitle('Classification Report'),
            _buildClassificationReportCard(),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk judul setiap bagian
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  // Helper widget untuk kartu gambar (Judul internal dihapus)
  Widget _buildImageCard(String imagePath) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
  
  // Helper widget untuk kartu Classification Report (Judul internal dihapus)
  Widget _buildClassificationReportCard() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16), // Padding atas ditambah sedikit
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: FixedColumnWidth(90.0),
              2: FixedColumnWidth(90.0),
              3: FixedColumnWidth(90.0),
              4: FixedColumnWidth(80.0),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableRow(
                ['Kelas', 'Precision', 'Recall', 'F1-Score', 'Support'],
                isHeader: true,
              ),
              _buildTableRow(['daun_sehat', '1.0000', '0.9900', '0.9950', '100']),
              _buildTableRow(['daun_kuning', '0.9901', '1.0000', '0.9950', '100']),
              _buildTableRow(['daun_bercak', '1.0000', '1.0000', '1.0000', '100']),
              _buildTableRow(['daun_busuk', '1.0000', '1.0000', '1.0000', '100']),
              _buildTableRow(['Accuracy', '', '', '0.9975', '400'], isFooter: true),
              _buildTableRow(['Macro Avg', '0.9975', '0.9975', '0.9975', '400'], isFooter: true),
              _buildTableRow(['Weighted Avg', '0.9975', '0.9975', '0.9975', '400'], isFooter: true),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk membuat baris tabel
  TableRow _buildTableRow(List<String> cells, {bool isHeader = false, bool isFooter = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[200] : null,
      ),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text(
            cell,
            textAlign: cell.contains('.') || cell.length <= 4 && cell.isNotEmpty ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontWeight: isHeader || isFooter ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.black87 : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}