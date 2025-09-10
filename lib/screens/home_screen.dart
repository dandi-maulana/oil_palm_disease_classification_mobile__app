// lib/screens/home_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pilihGambar(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      appProvider.setSelectedImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Penyakit Sawit'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Area Tampilan Gambar
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: provider.selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            provider.selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Belum ada gambar dipilih',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Tombol
            ElevatedButton.icon(
              onPressed: () => _pilihGambar(context),
              icon: const Icon(Icons.image),
              label: const Text('Pilih Gambar dari Galeri'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                final provider = Provider.of<AppProvider>(context, listen: false);
                if (provider.selectedImage != null) {
                   provider.getPrediction();
                }
              },
              icon: const Icon(Icons.analytics),
              label: const Text('Analisis Gambar'),
               style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Area Hasil
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Text(
                    'Error: ${provider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  );
                }
                if (provider.predictionResult != null) {
                  final result = provider.predictionResult!;
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.prediksi,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: result.prediksi == 'Daun Sehat' ? Colors.green : Colors.red,
                            ),
                          ),
                          Text('Kepercayaan: ${result.kepercayaan}', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 12),
                          const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(result.deskripsi),
                           const SizedBox(height: 8),
                          const Text('Saran:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(result.saran),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: Text('Hasil analisis akan muncul di sini.'));
              },
            ),
          ],
        ),
      ),
    );
  }
}