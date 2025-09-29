// lib/providers/app_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/prediction_result.dart';
import '../models/disease_sample.dart';
import '../models/history_item.dart';

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State untuk deteksi
  bool _isLoading = false;
  PredictionResult? _predictionResult;
  String? _errorMessage;
  File? _selectedImage;

  // State untuk data dinamis dan riwayat
  List<DiseaseSample> _samples = [];
  List<HistoryItem> _history = [];
  bool _isDataLoading = true;
  bool _isHistoryLoading = false;
  String _searchQuery = '';
  int _historyPage = 1;
  bool _hasMoreHistory = true;

  // Getters
  bool get isLoading => _isLoading;
  PredictionResult? get predictionResult => _predictionResult;
  String? get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;
  List<DiseaseSample> get samples => _samples;
  List<HistoryItem> get history => _history;
  bool get isDataLoading => _isDataLoading;
  bool get isHistoryLoading => _isHistoryLoading;
  bool get hasMoreHistory => _hasMoreHistory;

  AppProvider() {
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    _isDataLoading = true;
    notifyListeners();
    try {
      await Future.wait([
        _apiService.fetchSamples().then((value) => _samples = value),
        fetchHistory(isNewSearch: true),
      ]);
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      _isDataLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory({bool isNewSearch = false}) async {
    if (_isHistoryLoading || (!isNewSearch && !_hasMoreHistory)) return;

    _isHistoryLoading = true;
    if (isNewSearch) {
      _historyPage = 1;
      _history = [];
      _hasMoreHistory = true;
    }
    // Hanya panggil notifyListeners jika ada perubahan signifikan
    if(isNewSearch) notifyListeners();

    try {
      final result = await _apiService.fetchHistory(query: _searchQuery, page: _historyPage);
      _history.addAll(result['items']);
      _hasMoreHistory = result['has_more'];
      _historyPage++;
    } catch (e) {
      print("Error fetching history: $e");
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }

  void searchHistory(String query) {
    if (query == _searchQuery) return;
    _searchQuery = query;
    fetchHistory(isNewSearch: true);
  }

  void setSelectedImage(File? image) {
    _selectedImage = image;
    _predictionResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _predictionResult = null;
    _errorMessage = null;
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> getPrediction({
    required String namaPenguji,
    required String lokasiPengujian,
  }) async {
    if (_selectedImage == null) return;
    
    _isLoading = true;
    _errorMessage = null;
    _predictionResult = null; // Pastikan hasil lama dibersihkan
    notifyListeners(); // <-- Memberi tahu UI untuk menampilkan loading spinner

    try {
      _predictionResult = await _apiService.uploadImage(
        imageFile: _selectedImage!,
        namaPenguji: namaPenguji,
        lokasiPengujian: lokasiPengujian,
      );
      // Refresh total riwayat dengan pencarian kosong
      searchHistory('');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // <-- Memberi tahu UI untuk menyembunyikan loading dan menampilkan hasil/error
    }
  }
}