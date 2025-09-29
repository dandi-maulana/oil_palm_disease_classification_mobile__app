// lib/screens/confirmation_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ConfirmationScreen extends StatefulWidget {
  final File imageFile;

  const ConfirmationScreen({super.key, required this.imageFile});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  void _submitAnalysis() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true; // Tampilkan loading
      });
      
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.getPrediction(
        namaPenguji: _namaController.text,
        lokasiPengujian: _lokasiController.text,
      ).then((_) {
        // Setelah selesai, kembali ke halaman home
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pengujian'),
        backgroundColor: const Color(0xFF1e3a8a),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview Gambar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  widget.imageFile,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Lengkapi Detail Pengujian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1e3a8a)),
              ),
              const Divider(height: 20),
              
              // Form Input
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Penguji',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi Pengujian',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Lokasi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 30),

              // Tombol Analisis
              _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submitAnalysis,
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('Analisis Sekarang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}