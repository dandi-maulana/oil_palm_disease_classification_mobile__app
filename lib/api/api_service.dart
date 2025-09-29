// lib/api/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/prediction_result.dart';
import '../models/disease_sample.dart';
import '../models/history_item.dart';
import '../config.dart'; // Import file config

class ApiService {
  // Menggunakan IP dari file config
  static const String _baseUrl = 'http://$API_IP:8000/api';

  /// Mengirim gambar dan detail pengujian ke server.
  Future<PredictionResult> uploadImage({
    required File imageFile,
    required String namaPenguji,
    required String lokasiPengujian,
  }) async {
    var uri = Uri.parse('$_baseUrl/mobile/predict');
    var request = http.MultipartRequest('POST', uri);

    // Menambahkan data teks ke request
    request.fields['nama_penguji'] = namaPenguji;
    request.fields['lokasi_pengujian'] = lokasiPengujian;

    // Menambahkan file gambar
    request.files.add(
      await http.MultipartFile.fromPath('gambar_sawit', imageFile.path),
    );

    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(respStr));
    } else {
      try {
        final errorJson = jsonDecode(respStr);
        throw Exception(errorJson['error'] ?? 'Gagal melakukan prediksi');
      } catch (e) {
         throw Exception('Gagal memproses respons error dari server. Status: ${response.statusCode}');
      }
    }
  }

  /// Mengambil daftar riwayat dengan fitur pencarian dan paginasi.
  Future<Map<String, dynamic>> fetchHistory({String query = '', int page = 1}) async {
    var uri = Uri.parse('$_baseUrl/mobile/history?page=$page&search=$query');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = (data['data'] as List)
          .map((item) => HistoryItem.fromJson(item))
          .toList();
      
      return {
        'items': items,
        'has_more': data['next_page_url'] != null,
      };
    } else {
      throw Exception('Gagal memuat riwayat');
    }
  }

  /// Mengambil detail satu item riwayat berdasarkan ID.
  Future<HistoryItem> fetchHistoryDetail(int id) async {
    var uri = Uri.parse('$_baseUrl/mobile/history/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return HistoryItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail riwayat');
    }
  }

  /// Mengambil data sampel penyakit.
  Future<List<DiseaseSample>> fetchSamples() async {
    var uri = Uri.parse('$_baseUrl/samples');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => DiseaseSample.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat sampel data');
    }
  }
}