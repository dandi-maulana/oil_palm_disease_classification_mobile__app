// lib/screens/home_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/prediction_result.dart';
import '../models/disease_sample.dart';
import 'disease_detail_screen.dart';
import 'confirmation_screen.dart'; // Import halaman konfirmasi

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fungsi ini sekarang akan NAVIGASI ke halaman baru
  Future<void> _pilihGambar(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80, maxWidth: 1024);

    if (pickedFile != null && context.mounted) {
      // Set gambar di provider agar bisa diakses di halaman lain
      Provider.of<AppProvider>(context, listen: false).setSelectedImage(File(pickedFile.path));
      // Pindah ke halaman konfirmasi dengan membawa file gambar
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(imageFile: File(pickedFile.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dr. Sawit'),
            backgroundColor: const Color(0xFF1e3a8a),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Jika tidak ada hasil (atau baru reset), tampilkan halaman sambutan.
                if (provider.predictionResult == null && provider.errorMessage == null && !provider.isLoading)
                  _buildWelcomeContent(context)
                // Jika ada, tampilkan konten hasil (loading, error, atau kartu hasil).
                else
                  _buildResultContent(context, provider),
                
                const SizedBox(height: 30),
                
                // Tampilkan sampel data hanya jika tidak sedang dalam proses deteksi
                if (provider.predictionResult == null && provider.errorMessage == null && !provider.isLoading)
                  _buildSampleDataSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildWelcomeContent(BuildContext context) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Icon(Icons.monitor_heart, size: 80, color: Colors.blue[800]),
          const SizedBox(height: 20),
          const Text('Deteksi Penyakit Daun Sawit', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1e3a8a))),
          const SizedBox(height: 12),
          const Text('Gunakan kamera atau galeri untuk mengunggah gambar dan dapatkan hasil diagnosis.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _pilihGambar(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Ambil Gambar dari Kamera'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _pilihGambar(context, ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Pilih Gambar dari Galeri'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[100], foregroundColor: Colors.blue[800], minimumSize: const Size(double.infinity, 50), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      );
  }

  Widget _buildResultContent(BuildContext context, AppProvider provider) {
    return Column(
      children: [
        if (provider.isLoading)
          const Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child: Center(child: CircularProgressIndicator())),
        if (provider.errorMessage != null)
          _buildErrorWidget(provider.errorMessage!),
        if (provider.predictionResult != null && provider.selectedImage != null)
          _buildResultCard(context, provider.predictionResult!, provider.selectedImage!),
          
        const SizedBox(height: 12),
        
        TextButton.icon(
          onPressed: () => provider.reset(),
          icon: const Icon(Icons.refresh),
          label: const Text('Uji Gambar Lain'),
        ),
      ],
    );
  }
  
  Widget _buildSampleDataSection(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pelajari Sampel Penyakit', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1e3a8a))),
        const SizedBox(height: 15),
        if (provider.isDataLoading) const Center(child: CircularProgressIndicator())
        else if (provider.samples.isEmpty) const Center(child: Text('Gagal memuat data sampel.'))
        else
          Column(
            children: provider.samples.map((disease) {
              return _buildDiseaseSampleCard(context, disease);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildDiseaseSampleCard(BuildContext context, DiseaseSample disease) {
    return Card(
      elevation: 3, margin: const EdgeInsets.symmetric(vertical: 8), color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiseaseDetailScreen(disease: disease))),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  disease.imagePath, width: 80, height: 80, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(width: 80, height: 80, color: Colors.grey[200], child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(disease.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3a8a))),
                    const SizedBox(height: 4),
                    Text(disease.description.split('.').first + '.', style: const TextStyle(fontSize: 14, color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiseaseDetailScreen(disease: disease))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, PredictionResult result, File imageFile) {
    final isHealthy = result.prediksi == 'Daun Sehat';
    final statusIcon = isHealthy ? Icon(Icons.check_circle, color: Colors.green[700], size: 28) : Icon(Icons.warning, color: Colors.orange[800], size: 28);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(imageFile, height: 250, width: double.infinity, fit: BoxFit.cover),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4, color: Colors.blue[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue[200]!, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    statusIcon,
                    const SizedBox(width: 10),
                    Expanded(child: Text(result.prediksi, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[900]))),
                  ],
                ),
                Text('Kepercayaan: ${result.kepercayaan}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                const Divider(height: 24),
                _buildDetailRow('Waktu Selesai:', result.waktuSelesai),
                _buildDetailRow('Durasi Analisis:', result.durasi),
                const Divider(height: 24),
                Text('💡 Informasi & Saran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[900])),
                const SizedBox(height: 8),
                Text('Deskripsi: ${result.deskripsi}', style: const TextStyle(height: 1.5)),
                const SizedBox(height: 8),
                Text('Saran: ${result.saran}', style: const TextStyle(height: 1.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16), margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red[200]!)),
      child: Text('Error: $message', style: TextStyle(color: Colors.red[800]), textAlign: TextAlign.center),
    );
  }
}