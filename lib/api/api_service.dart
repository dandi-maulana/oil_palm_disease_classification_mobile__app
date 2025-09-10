// lib/api/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/prediction_result.dart';

class ApiService {
  // PENTING: Ganti dengan alamat IP LOKAL laptop Anda!
  static const String _baseUrl = 'http://10.115.201.153:8000/api/predict';

  Future<PredictionResult> uploadImage(File imageFile) async {
    var uri = Uri.parse(_baseUrl);
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'gambar_sawit', // Nama field harus sama dengan di Laravel
        imageFile.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return PredictionResult.fromJson(jsonDecode(responseBody));
    } else {
      final responseBody = await response.stream.bytesToString();
      // Coba decode error dari server jika ada
      final errorJson = jsonDecode(responseBody);
      throw Exception(errorJson['error'] ?? 'Gagal melakukan prediksi');
    }
  }
}