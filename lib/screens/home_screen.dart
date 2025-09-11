// lib/screens/home_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/prediction_result.dart';
import '../models/disease_sample.dart';
import 'disease_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pilihGambar(BuildContext context, ImageSource source) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80, maxWidth: 1024);

    if (pickedFile != null) {
      appProvider.setSelectedImage(File(pickedFile.path));
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
                _buildWelcomeAndDetectionSection(context, provider),
                const SizedBox(height: 30),
                _buildSampleDataSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeAndDetectionSection(BuildContext context, AppProvider provider) {
    if (provider.selectedImage == null) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Icon(Icons.monitor_heart, size: 80, color: Colors.blue[800]),
          const SizedBox(height: 20),
          const Text(
            'Deteksi Penyakit Daun Sawit',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1e3a8a)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gunakan kamera atau galeri untuk mengunggah gambar daun kelapa sawit dan dapatkan hasil diagnosis.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _pilihGambar(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Ambil Gambar dari Kamera'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _pilihGambar(context, ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Pilih Gambar dari Galeri'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              foregroundColor: Colors.blue[800],
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else {
      return _buildResultContent(context, provider);
    }
  }

  Widget _buildSampleDataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pelajari Sampel Penyakit',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e3a8a),
          ),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: DiseaseSample.dummySamples.length,
          itemBuilder: (context, index) {
            final disease = DiseaseSample.dummySamples[index];
            return _buildDiseaseSampleCard(context, disease);
          },
        ),
      ],
    );
  }

  // === KARTU SAMPEL PENYAKIT DIPERBARUI DI SINI ===
  Widget _buildDiseaseSampleCard(BuildContext context, DiseaseSample disease) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      // WARNA KARTU DIUBAH MENJADI BIRU MUDA
      color: Colors.blue[50], 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiseaseDetailScreen(disease: disease),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  disease.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1e3a8a),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      disease.description.split('.').first + '.',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiseaseDetailScreen(disease: disease),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultContent(BuildContext context, AppProvider provider) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            provider.selectedImage!,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        if (!provider.isLoading && provider.predictionResult == null && provider.errorMessage == null)
          ElevatedButton.icon(
            onPressed: () => provider.getPrediction(),
            icon: const Icon(Icons.analytics),
            label: const Text('Analisis Gambar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        if (provider.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (provider.errorMessage != null)
          _buildErrorWidget(provider.errorMessage!),
        if (provider.predictionResult != null)
          _buildResultCard(provider.predictionResult!),
        const SizedBox(height: 12),
        if (provider.selectedImage != null)
          TextButton.icon(
            onPressed: () => provider.reset(),
            icon: const Icon(Icons.refresh),
            label: const Text('Uji Gambar Lain'),
          ),
      ],
    );
  }
  
  Widget _buildResultCard(PredictionResult result) {
    final isHealthy = result.prediksi == 'Daun Sehat';
    final statusIcon = isHealthy
        ? Icon(Icons.check_circle, color: Colors.green[700], size: 28)
        : Icon(Icons.warning, color: Colors.orange[800], size: 28);

    return Card(
      elevation: 4,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                statusIcon,
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    result.prediksi,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
            Text(
              'Kepercayaan: ${result.kepercayaan}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const Divider(height: 24),
            Text('💡 Informasi & Saran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[900])),
            const SizedBox(height: 8),
            Text('Deskripsi: ${result.deskripsi}', style: const TextStyle(height: 1.5)),
            const SizedBox(height: 8),
            Text('Saran: ${result.saran}', style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Text(
        'Error: $message',
        style: TextStyle(color: Colors.red[800]),
        textAlign: TextAlign.center,
      ),
    );
  }
}